import AVFoundation
import SwiftData
import SwiftUI

struct EntryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.indexing) private var indexing
    @Environment(\.dismiss) private var dismiss

    @State var entry: JournalEntry
    @State private var confirmDelete: Bool = false
    @State private var showingMoodInfo: Bool = false
    @State private var showingTagSheet: Bool = false
    @State private var showingThreadSheet: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Editable title
                TextField("Title (optional)", text: Binding(get: { entry.title ?? "" }, set: { newVal in entry.title = newVal.isEmpty ? nil : newVal; try? modelContext.save() }))
                    .font(.title3.weight(.semibold))
                    .textInputAutocapitalization(.sentences)
                    .disableAutocorrection(false)
                if let summary = entry.summary, !summary.isEmpty {
                    Text(summary).font(.title3.weight(.semibold))
                        .contextMenu {
                            Button("Regenerate Summary") { Task { await regenerateSummary() } }
                        }
                }
                if let score = entry.moodScore, let label = entry.moodLabel {
                    HStack(spacing: 8) {
                        MoodBadge(label: label, score: score)
                        Button {
                            showingMoodInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                        }.buttonStyle(.plain)
                    }
                }
                if let audio = entry.audio {
                    Divider()
                    AudioPlayerView(url: audio.resolvedFileURL)
                }
                Divider()
                // Tags editor
                tagsEditor
                // Thread assignment
                threadEditor
                Divider()
                Text(entry.transcript)
                    .font(.body)
                    .textSelection(.enabled)
                // Editable notes
                VStack(alignment: .leading, spacing: 6) {
                    Text("Notes").font(.headline)
                    TextEditor(text: Binding(get: { entry.notes ?? "" }, set: { newVal in entry.notes = newVal.isEmpty ? nil : newVal }))
                        .frame(minHeight: 120)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.quaternary))
                        .onChange(of: entry.notes ?? "") { try? modelContext.save() }
                }
                Spacer(minLength: 12)
                ShareLink(item: entry.summary ?? entry.transcript) { Label("Share", systemImage: "square.and.arrow.up") }
            }
            .padding()
        }
        .navigationTitle(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    Button {
                        entry.isPinned.toggle()
                        try? modelContext.save()
                    } label: { Label(entry.isPinned ? "Unpin" : "Pin", systemImage: entry.isPinned ? "pin.slash" : "pin.fill") }
                    Button(role: .destructive) { confirmDelete = true } label: { Label("Delete", systemImage: "trash") }
                } label: { Image(systemName: "ellipsis.circle") }
            }
        }
        .alert("Delete this entry?", isPresented: $confirmDelete) {
            Button("Delete", role: .destructive) { deleteEntry() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $showingMoodInfo) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("About mood signal").font(.title2.bold())
                    Text("Sonar estimates mood locally using Apple's on‑device sentiment. Scores range from −1 to +1 and are grouped as Negative, Neutral, or Positive. Your content never leaves the device.")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding()
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Close") { showingMoodInfo = false } } }
            }
            .presentationDetents([.medium])
        }
    }

    @Environment(\.summarization) private var summarization
    @Environment(\.modelContext) private var ctx
    private func regenerateSummary() async {
        let transcript = entry.transcript
        let maxSentences = 3
        let newSummary = await summarization.summarize(text: transcript, maxSentences: maxSentences, toneHint: nil)
        await MainActor.run {
            entry.summary = newSummary
            try? ctx.save()
        }
        Task { await indexing.index(entry: entry) }
    }

    private func deleteEntry() {
        modelContext.delete(entry)
        try? modelContext.save()
        Task { await indexing.deleteIndex(for: entry.id) }
        dismiss()
    }
}

// MARK: - Tags Editor

private extension EntryDetailView {
    @ViewBuilder var tagsEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Tags").font(.headline)
                Spacer()
                Button { showingTagSheet = true } label: { Label("Edit", systemImage: "tag") }
                    .buttonStyle(.bordered)
            }
            if entry.tags.isEmpty {
                Text("No tags").foregroundStyle(.secondary)
            } else {
                FlowLayout(entry.tags.map(\.name)) { name in
                    Text(name)
                        .font(.caption)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.accentColor.opacity(0.15), in: Capsule())
                }
            }
        }
        .sheet(isPresented: $showingTagSheet) { TagsSheet(entry: $entry) }
    }
}

// MARK: - Tags Sheet

private struct TagsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tag.name) private var allTags: [Tag]
    @Binding var entry: JournalEntry
    @State private var newTagName: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Add Tag") {
                    HStack {
                        TextField("New tag", text: $newTagName)
                        Button("Add") { addTag() }.disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                Section("All Tags") {
                    ForEach(allTags) { tag in
                        Button {
                            toggle(tag)
                        } label: {
                            HStack {
                                Text(tag.name)
                                Spacer()
                                if entry.tags.contains(where: { $0.id == tag.id }) { Image(systemName: "checkmark") }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Tags")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }
    }

    private func addTag() {
        let name = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        if let existing = allTags.first(where: { $0.name.caseInsensitiveCompare(name) == .orderedSame }) {
            toggle(existing)
        } else {
            let t = Tag(name: name)
            modelContext.insert(t)
            entry.tags.append(t)
            try? modelContext.save()
        }
        newTagName = ""
    }

    private func toggle(_ tag: Tag) {
        if let idx = entry.tags.firstIndex(where: { $0.id == tag.id }) {
            entry.tags.remove(at: idx)
        } else {
            entry.tags.append(tag)
        }
        try? modelContext.save()
    }
}

// MARK: - Thread Editor

private extension EntryDetailView {
    @ViewBuilder var threadEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Thread").font(.headline)
                Spacer()
                Button { showingThreadSheet = true } label: { Label("Assign", systemImage: "rectangle.connected.to.line.below") }
                    .buttonStyle(.bordered)
            }
            if let thread = entryThreadTitle() {
                Text(thread).font(.subheadline).foregroundStyle(.secondary)
            } else {
                Text("No thread").foregroundStyle(.secondary)
            }
        }
        .sheet(isPresented: $showingThreadSheet) { ThreadSheet(entry: $entry) }
    }

    func entryThreadTitle() -> String? {
        // Use first associated thread title if any
        // We don’t have a back-reference on JournalEntry, so infer via any MemoryThread that contains this entry
        let ctx = modelContext
        if let threads: [MemoryThread] = try? ctx.fetch(FetchDescriptor<MemoryThread>()) {
            return threads.first(where: { t in t.entries.contains(where: { $0.id == entry.id }) })?.title
        }
        return nil
    }
}

private struct ThreadSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MemoryThread.title) private var threads: [MemoryThread]
    @Binding var entry: JournalEntry
    @State private var newTitle: String = ""

    var body: some View {
        NavigationStack {
            List {
                Section("New Thread") {
                    HStack {
                        TextField("Title", text: $newTitle)
                        Button("Add") { addThread() }.disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                Section("All Threads") {
                    ForEach(threads) { thread in
                        Button { assign(thread) } label: {
                            HStack {
                                Text(thread.title)
                                Spacer()
                                if isAssigned(thread) { Image(systemName: "checkmark") }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Assign Thread")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }
    }

    private func addThread() {
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        if let existing = threads.first(where: { $0.title.caseInsensitiveCompare(title) == .orderedSame }) {
            assign(existing)
        } else {
            let t = MemoryThread(title: title)
            modelContext.insert(t)
            // Uniquely assign entry to this thread (not enforcing exclusivity globally here)
            t.entries.append(entry)
            try? modelContext.save()
        }
        newTitle = ""
    }

    private func assign(_ thread: MemoryThread) {
        if isAssigned(thread) {
            // Unassign
            if let i = thread.entries.firstIndex(where: { $0.id == entry.id }) { thread.entries.remove(at: i) }
        } else {
            thread.entries.append(entry)
        }
        try? modelContext.save()
    }

    private func isAssigned(_ thread: MemoryThread) -> Bool {
        thread.entries.contains(where: { $0.id == entry.id })
    }
}

// MARK: - Simple flow layout for tag chips

private struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    private let data: Data
    private let content: (Data.Element) -> Content
    init(_ data: Data, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    var body: some View {
        var width: CGFloat = .zero
        var height: CGFloat = .zero
        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(Array(data), id: \.self) { item in
                    content(item)
                        .padding(4)
                        .alignmentGuide(.leading) { d in
                            if abs(width - d.width) > geometry.size.width { width = 0; height -= d.height }
                            let result = width
                            if item == data.last { width = 0 } else { width -= d.width }
                            return result
                        }
                        .alignmentGuide(.top) { _ in height }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 0)
    }
}

private struct AudioPlayerView: View {
    let url: URL
    @State private var player: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var rate: Float = 1.0
    @State private var progress: Double = 0
    @State private var loadFailed: Bool = false
    @State private var progressTask: Task<Void, Never>? = nil
    @State private var playerDelegate = PlayerDelegate()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 16) {
                Button {
                    togglePlayback()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                }
                Stepper("Speed: \(String(format: "%.1fx", rate))", value: $rate, in: 0.5 ... 2.0, step: 0.25)
                    .onChange(of: rate) { newRate in
                        player?.enableRate = true
                        player?.rate = newRate
                    }
            }
            Slider(value: Binding(get: { progress }, set: { newVal in
                progress = newVal
                if let player { player.currentTime = newVal * player.duration }
            }))
            .disabled(player == nil)
            .accessibilityLabel("Playback position")
            if loadFailed {
                Text("Unable to load audio")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear { preparePlayerIfNeeded() }
        .onDisappear {
            player?.stop()
            isPlaying = false
            progressTask?.cancel()
            progressTask = nil
        }
    }

    private func preparePlayerIfNeeded() {
        guard player == nil else { return }
        do {
            // For playback category, do not use .defaultToSpeaker. That option is for playAndRecord.
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            let audio = try AVAudioPlayer(contentsOf: url)
            audio.enableRate = true
            audio.delegate = playerDelegate
            audio.prepareToPlay()
            player = audio
            // Handle end-of-playback to update UI
            playerDelegate.onFinish = { [weak player] in
                Task { @MainActor in
                    isPlaying = false
                    progress = 0
                    player?.stop()
                    player?.currentTime = 0
                }
            }
            startProgressLoop()
            loadFailed = false
        } catch {
            loadFailed = true
            player = nil
        }
    }

    private func togglePlayback() {
        if player == nil { preparePlayerIfNeeded() }
        guard let player else { return }
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            player.rate = rate
            isPlaying = true
        }
    }

    private func startProgressLoop() {
        progressTask?.cancel()
        progressTask = Task { @MainActor in
            while !Task.isCancelled {
                if let player {
                    let dur = player.duration
                    let cur = player.currentTime
                    progress = dur > 0 ? cur / dur : 0
                    if isPlaying, cur >= dur - 0.01 {
                        // Reached end
                        isPlaying = false
                        player.stop()
                        player.currentTime = 0
                    }
                }
                try? await Task.sleep(for: .milliseconds(200))
            }
        }
    }
}

private final class PlayerDelegate: NSObject, AVAudioPlayerDelegate {
    var onFinish: (() -> Void)?
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        onFinish?()
    }
}

#Preview {
    NavigationStack { EntryDetailView(entry: JournalEntry(transcript: "A sample transcript.")) }
}
