import SwiftData
import SwiftUI

struct EntriesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.sortRank, order: .reverse) private var entries: [JournalEntry]

    var body: some View {
        List {
            ForEach(entries, id: \.id) { entry in
                NavigationLink {
                    EntryDetailView(entry: entry)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.summary ?? String(entry.transcript.prefix(80)))
                            .font(.headline)
                        HStack(spacing: 12) {
                            if let label = entry.moodLabel {
                                MoodBadge(label: label, score: entry.moodScore ?? 0)
                            }
                            Text(entry.createdAt, style: .date)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .onMove(perform: move)
        }
        .navigationTitle("Journal")
        .toolbar { EditButton() }
        .overlay {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No entries yet",
                    systemImage: "mic",
                    description: Text("Tap the mic to start your first journal.")
                )
            }
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        var current = entries
        current.move(fromOffsets: source, toOffset: destination)
        // Re-rank
        for (index, entry) in current.enumerated() {
            entry.sortRank = Double(current.count - index)
        }
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack { EntriesListView() }
}
