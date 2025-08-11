import SwiftData
import SwiftUI

struct SearchFilterView: View {
    @State private var query = ""
    @State private var moodBin: Int? = nil
    @State private var datePreset: Int? = nil // 0: Today, 1: Last 7 days
    @State private var selectedTags: Set<String> = []

    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]

    var body: some View {
        List(filtered(entries)) { entry in
            NavigationLink {
                EntryDetailView(entry: entry)
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.summary ?? String(entry.transcript.prefix(120)))
                        .font(.headline)
                    HStack(spacing: 12) {
                        if let label = entry.moodLabel { MoodBadge(label: label, score: entry.moodScore ?? 0) }
                        Text(entry.createdAt, style: .date).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Search")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { filterMenu } }
        .searchable(text: $query)
        .overlay {
            if entries.isEmpty {
                ContentUnavailableView("No entries yet", systemImage: "mic", description: Text("Record to start building your journal."))
            } else if filtered(entries).isEmpty, !query.isEmpty {
                ContentUnavailableView("No results", systemImage: "magnifyingglass", description: Text("Try broadening your query or clearing filters."))
            }
        }
    }

    private var filterMenu: some View {
        Menu {
            Picker("Mood", selection: $moodBin) {
                Text("Any").tag(Int?.none)
                Text("Negative").tag(Optional(0))
                Text("Neutral").tag(Optional(1))
                Text("Positive").tag(Optional(2))
            }
            Picker("Date", selection: $datePreset) {
                Text("Any").tag(Int?.none)
                Text("Today").tag(Optional(0))
                Text("Last 7 days").tag(Optional(1))
            }
            Menu("Tags") {
                let allTags: [String] = Array(Set(entries.flatMap { $0.tags.map(\.name) })).sorted()
                ForEach(allTags, id: \.self) { tagName in
                    Button {
                        if selectedTags.contains(tagName) { selectedTags.remove(tagName) } else { selectedTags.insert(tagName) }
                    } label: {
                        HStack { Text(tagName); Spacer(); if selectedTags.contains(tagName) { Image(systemName: "checkmark") } }
                    }
                }
            }
            Button("Clear filters") { moodBin = nil; datePreset = nil; selectedTags.removeAll() }
        } label: {
            Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
        }
    }

    private func filtered(_ all: [JournalEntry]) -> [JournalEntry] {
        let range: ClosedRange<Date>? = switch datePreset {
        case 0: Calendar.current.startOfDay(for: .now) ... Date()
        case 1: Calendar.current.date(byAdding: .day, value: -7, to: .now)! ... Date()
        default: nil
        }
        return all.filter { entry in
            var include = true
            if !query.isEmpty {
                let text = entry.transcript + "\n" + (entry.summary ?? "")
                include = include && text.localizedCaseInsensitiveContains(query)
            }
            if let moodBin { include = include && moodMatches(entry.moodScore, bin: moodBin) }
            if let range { include = include && range.contains(entry.createdAt) }
            if !selectedTags.isEmpty { include = include && !Set(entry.tags.map(\.name)).intersection(selectedTags).isEmpty }
            return include
        }
    }

    private func moodMatches(_ score: Double?, bin: Int) -> Bool {
        guard let s = score else { return false }
        switch bin { case 0: return s < -0.2; case 1: return abs(s) <= 0.2; case 2: return s > 0.2; default: return true }
    }
}

#Preview { NavigationStack { SearchFilterView() } }
