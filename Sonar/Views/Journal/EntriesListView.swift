import SwiftData
import SwiftUI

struct EntriesListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.indexing) private var indexing
    @Query(sort: \JournalEntry.sortRank, order: .reverse) private var entries: [JournalEntry]
    @State private var selection: Set<UUID> = []
    @State private var query: String = ""
    @State private var moodBin: Int? = nil
    @State private var dateRange: ClosedRange<Date>? = nil
    @State private var datePreset: Int? = nil // 0: Today, 1: Last 7 days
    @State private var selectedTags: Set<String> = []

    var body: some View {
        let pinned = entries.filter(\.isPinned)
        let others = entries.filter { !$0.isPinned }

        List(selection: $selection) {
            if !pinned.isEmpty {
                Section("Pinned") {
                    ForEach(filtered(pinned), id: \.id) { entry in
                        row(entry, highlight: query)
                            .tag(entry.id)
                    }
                }
            }
            Section("Recent") {
                ForEach(filtered(others), id: \.id) { entry in
                    row(entry, highlight: query)
                        .tag(entry.id)
                }
                .onMove { source, destination in moveWithinOthers(others: others, source: source, destination: destination) }
            }
        }
        .navigationTitle("Journal")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { filterMenu }
            ToolbarItem(placement: .topBarTrailing) {
                if !selection.isEmpty {
                    Button(role: .destructive) { deleteSelected() } label: { Label("Delete", systemImage: "trash") }
                } else {
                    EditButton()
                }
            }
        }
        .searchable(text: $query)
        .overlay {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No entries yet",
                    systemImage: "mic",
                    description: Text("Tap the mic to start your first journal.")
                )
            } else if filtered(others).isEmpty, filtered(pinned).isEmpty, !query.isEmpty {
                ContentUnavailableView(
                    "No results",
                    systemImage: "magnifyingglass",
                    description: Text("Try broadening your query or clearing filters.")
                )
            }
        }
        .onAppear { selection.removeAll() }
    }

    @State private var shareText: String? = nil

    @ViewBuilder private func row(_ entry: JournalEntry, highlight query: String = "") -> some View {
        NavigationLink {
            EntryDetailView(entry: entry)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                highlightedText(entry.summary ?? String(entry.transcript.prefix(80)), query: query)
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
        .swipeActions(edge: .trailing) {
            Button {
                entry.isPinned.toggle()
                try? modelContext.save()
            } label: {
                Label(entry.isPinned ? "Unpin" : "Pin", systemImage: entry.isPinned ? "pin.slash" : "pin.fill")
            }.tint(.orange)
            Button(role: .destructive) {
                let id = entry.id
                modelContext.delete(entry)
                try? modelContext.save()
                Task { await indexing.deleteIndex(for: id) }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            ShareLink(item: entry.summary ?? entry.transcript) { Label("Share", systemImage: "square.and.arrow.up") }
                .tint(.blue)
        }
        .contextMenu {
            Button {
                entry.isPinned.toggle(); try? modelContext.save()
            } label: { Label(entry.isPinned ? "Unpin" : "Pin", systemImage: entry.isPinned ? "pin.slash" : "pin.fill") }
            ShareLink(item: entry.summary ?? entry.transcript) { Label("Share", systemImage: "square.and.arrow.up") }
            Button(role: .destructive) {
                let id = entry.id
                modelContext.delete(entry)
                try? modelContext.save()
                Task { await indexing.deleteIndex(for: id) }
            } label: { Label("Delete", systemImage: "trash") }
        }
    }

    @ViewBuilder private func highlightedText(_ text: String, query: String) -> some View {
        if query.isEmpty { Text(text) }
        else {
            let parts = text.components(separatedBy: query)
            let intersperse: [Text] = parts.enumerated().flatMap { idx, part -> [Text] in
                var res: [Text] = [Text(part)]
                if idx < parts.count - 1 { res.append(Text(query).bold().foregroundStyle(Color.accentColor)) }
                return res
            }
            intersperse.dropFirst().reduce(Text(parts.first ?? "")) { acc, nxt in acc + nxt }
        }
    }

    private func moveWithinOthers(others: [JournalEntry], source: IndexSet, destination: Int) {
        var mutable = others
        mutable.move(fromOffsets: source, toOffset: destination)
        for (index, entry) in mutable.enumerated() {
            entry.sortRank = Double(mutable.count - index)
        }
        try? modelContext.save()
    }

    private var filterMenu: some View {
        Menu {
            Picker("Mood", selection: $moodBin) {
                Text("Any").tag(Int?.none)
                Text("Negative").tag(Optional(0))
                Text("Neutral").tag(Optional(1))
                Text("Positive").tag(Optional(2))
            }
            Picker("Date", selection: Binding(
                get: { datePreset },
                set: { newValue in
                    datePreset = newValue
                }
            )) {
                Text("Any").tag(Int?.none)
                Text("Today").tag(Optional(0))
                Text("Last 7 days").tag(Optional(1))
            }
            Menu("Tags") {
                let allTags: [String] = Array(Set(entries.flatMap { $0.tags.map(\.name) }))
                ForEach(allTags, id: \.self) { tagName in
                    Button {
                        if selectedTags.contains(tagName) { selectedTags.remove(tagName) } else { selectedTags.insert(tagName) }
                    } label: {
                        HStack { Text(tagName); Spacer(); if selectedTags.contains(tagName) { Image(systemName: "checkmark") } }
                    }
                }
            }
            Button("Clear filters") { moodBin = nil; dateRange = nil; datePreset = nil; selectedTags.removeAll() }
        } label: {
            Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
        }
    }

    private func filtered(_ list: [JournalEntry]) -> [JournalEntry] {
        // Compute date range derived from preset locally to avoid mutating state during view updates
        let activeRange: ClosedRange<Date>? = switch datePreset {
        case 0: Calendar.current.startOfDay(for: .now) ... Date()
        case 1: Calendar.current.date(byAdding: .day, value: -7, to: .now)! ... Date()
        default: nil
        }

        return list.filter { entry in
            var include = true
            if !query.isEmpty {
                let text = entry.transcript + "\n" + (entry.summary ?? "")
                include = include && text.localizedCaseInsensitiveContains(query)
            }
            if let moodBin { include = include && moodMatches(entry.moodScore, bin: moodBin) }
            if let range = activeRange { include = include && range.contains(entry.createdAt) }
            if !selectedTags.isEmpty { include = include && !Set(entry.tags.map(\.name)).intersection(selectedTags).isEmpty }
            return include
        }
    }

    private func moodMatches(_ score: Double?, bin: Int) -> Bool {
        guard let s = score else { return false }
        switch bin { case 0: return s < -0.2; case 1: return abs(s) <= 0.2; case 2: return s > 0.2; default: return true }
    }

    private func deleteSelected() {
        let ids = selection
        guard !ids.isEmpty else { return }
        for entry in entries where ids.contains(entry.id) {
            let id = entry.id
            modelContext.delete(entry)
            Task { await indexing.deleteIndex(for: id) }
        }
        try? modelContext.save()
        selection.removeAll()
    }
}

// Deprecated: share container sheet removed

#Preview {
    NavigationStack { EntriesListView() }
}
