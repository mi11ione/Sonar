import SwiftData
import SwiftUI

struct SearchFilterView: View {
    @State private var query: String = ""
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]

    var body: some View {
        List(filtered(entries), id: \.id) { entry in
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
        .searchable(text: $query)
        .navigationTitle("Search")
    }

    private func filtered(_ all: [JournalEntry]) -> [JournalEntry] {
        guard !query.isEmpty else { return all }
        return all.filter { entry in
            let text = entry.transcript + "\n" + (entry.summary ?? "")
            return text.localizedCaseInsensitiveContains(query)
        }
    }
}

#Preview {
    NavigationStack { SearchFilterView() }
}
