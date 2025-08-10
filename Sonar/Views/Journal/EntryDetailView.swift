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
                }
                if let score = entry.moodScore, let label = entry.moodLabel {
                    MoodBadge(label: label, score: score)
                }
                if let audio = entry.audio {
                    Divider()
                    AudioPlayerView(url: audio.fileURL)
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
                Button(entry.isPinned ? "Unpin" : "Pin") {
                    entry.isPinned.toggle()
                    try? modelContext.save()
                }
                Menu {
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

    private func deleteEntry() {
        modelContext.delete(entry)
        try? modelContext.save()
        Task { await indexing.deleteIndex(for: entry.id) }
        dismiss()
    }
}

private struct AudioPlayerView: View {
    let url: URL
    @State private var isPlaying = false
    @State private var rate: Float = 1.0
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button { isPlaying.toggle() } label: { Image(systemName: isPlaying ? "pause.fill" : "play.fill") }
                Stepper("Speed: \(String(format: "%.1fx", rate))", value: $rate, in: 0.5 ... 2.0, step: 0.25)
            }
        }
    }
}

#Preview {
    NavigationStack { EntryDetailView(entry: JournalEntry(transcript: "A sample transcript.")) }
}
