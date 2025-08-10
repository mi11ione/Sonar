import SwiftData
import SwiftUI

struct EntriesListView: View {
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]

    var body: some View {
        List(entries, id: \.id) { entry in
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
        .navigationTitle("Journal")
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
}

#Preview {
    NavigationStack { EntriesListView() }
}
