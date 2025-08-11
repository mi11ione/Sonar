import SwiftData
import SwiftUI

struct ThreadsListView: View {
    @Query(sort: \MemoryThread.title) private var threads: [MemoryThread]
    @State private var renamingThread: MemoryThread? = nil
    @State private var renameText: String = ""
    var body: some View {
        List {
            ForEach(threads) { thread in
                NavigationLink(destination: ThreadDetailView(thread: thread)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(thread.title).font(.headline)
                            Text("\(thread.entries.count) entries").font(.caption).foregroundStyle(.secondary)
                            // Simple inline highlights using most common tag names in this thread
                            if let highlight = topThemes(for: thread).first {
                                Text("Theme: \(highlight)").font(.caption2).foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        if let avg = averageMood(for: thread) {
                            MoodBadge(label: label(for: avg), score: avg)
                        }
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button("Rename") { renamingThread = thread; renameText = thread.title }.tint(.blue)
                }
            }
        }
        .navigationTitle("Threads")
        .overlay {
            if threads.isEmpty {
                ContentUnavailableView("No threads yet", systemImage: "rectangle.connected.to.line.below", description: Text("Assign entries to threads from entry details."))
            }
        }
        .alert("Rename Thread", isPresented: Binding(get: { renamingThread != nil }, set: { if !$0 { renamingThread = nil } })) {
            TextField("Title", text: $renameText)
            Button("Save") { rename() }
            Button("Cancel", role: .cancel) { renamingThread = nil }
        }
    }

    private func averageMood(for thread: MemoryThread) -> Double? {
        let scores = thread.entries.compactMap(\.moodScore)
        guard !scores.isEmpty else { return nil }
        return scores.reduce(0, +) / Double(scores.count)
    }

    private func topThemes(for thread: MemoryThread) -> [String] {
        let tokens = thread.entries.flatMap { $0.tags.map(\.name) }
        guard !tokens.isEmpty else { return [] }
        let freq = Dictionary(grouping: tokens, by: { $0 }).mapValues(\.count)
        return Array(freq.sorted { $0.value > $1.value }.prefix(3).map(\.key))
    }

    private func label(for score: Double) -> String {
        if score > 0.2 { return "Positive" }
        if score < -0.2 { return "Negative" }
        return "Neutral"
    }

    private func rename() {
        guard let thread = renamingThread else { return }
        let title = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        thread.title = title
        renamingThread = nil
    }
}

struct ThreadDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State var thread: MemoryThread

    var body: some View {
        List {
            ForEach(thread.entries.sorted(by: { $0.createdAt > $1.createdAt })) { entry in
                NavigationLink(destination: EntryDetailView(entry: entry)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.summary ?? String(entry.transcript.prefix(80)))
                            .font(.headline)
                        HStack(spacing: 12) {
                            if let label = entry.moodLabel { MoodBadge(label: label, score: entry.moodScore ?? 0) }
                            Text(entry.createdAt, style: .date).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(thread.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Rename") { rename() }
            }
        }
    }

    private func rename() {
        // Simple inline rename via alert text field is not available; use a quick sheet in future iterations.
    }
}

#Preview { NavigationStack { ThreadsListView() } }
