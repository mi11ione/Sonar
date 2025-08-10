import SwiftUI
import SwiftData

struct EntryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.indexing) private var indexing

    @State var entry: JournalEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let summary = entry.summary, !summary.isEmpty {
                    Text(summary).font(.title3.weight(.semibold))
                }
                if let score = entry.moodScore, let label = entry.moodLabel {
                    MoodBadge(label: label, score: score)
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
                    Button(role: .destructive) { deleteEntry() } label: { Label("Delete", systemImage: "trash") }
                } label: { Image(systemName: "ellipsis.circle") }
            }
        }
    }

    private func deleteEntry() {
        modelContext.delete(entry)
        try? modelContext.save()
        Task { await indexing.deleteIndex(for: entry.id) }
    }
}

#Preview {
    NavigationStack { EntryDetailView(entry: JournalEntry(transcript: "A sample transcript.")) }
}


