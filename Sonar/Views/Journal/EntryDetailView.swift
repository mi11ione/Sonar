import AVFoundation
import SwiftData
import SwiftUI

struct EntryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.indexing) private var indexing
    @Environment(\.dismiss) private var dismiss

    @State var entry: JournalEntry
    @State private var confirmDelete: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let summary = entry.summary, !summary.isEmpty {
                    Text(summary).font(.title3.weight(.semibold))
                        .contextMenu {
                            Button("Regenerate Summary") { Task { await regenerateSummary() } }
                        }
                }
                if let score = entry.moodScore, let label = entry.moodLabel {
                    MoodBadge(label: label, score: score)
                }
                if let audio = entry.audio {
                    Divider()
                    AudioPlayerView(url: audio.resolvedFileURL)
                }
                Divider()
                Text(entry.transcript)
                    .font(.body)
                    .textSelection(.enabled)
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
    }

    private func deleteEntry() {
        modelContext.delete(entry)
        try? modelContext.save()
        Task { await indexing.deleteIndex(for: entry.id) }
        dismiss()
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
