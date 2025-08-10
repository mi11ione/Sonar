import SwiftData
import SwiftUI

struct EntriesListView: View {
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]

    var body: some View {
        List(entries, id: \.id) { entry in
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.summary ?? String(entry.transcript.prefix(80)))
                    .font(.headline)
                HStack(spacing: 12) {
                    if let label = entry.moodLabel {
                        Text(label)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.quaternary, in: Capsule())
                    }
                    Text(entry.createdAt, style: .date)
                        .foregroundStyle(.secondary)
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
