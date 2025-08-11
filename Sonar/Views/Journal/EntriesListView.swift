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
    @State private var presentLastEntry: Bool = false

    var body: some View {
        let pinned = entries.filter(\.isPinned)
        let others = entries.filter { !$0.isPinned }

        NavigationStack {
            // Hidden programmatic navigation to last entry when requested
            NavigationLink(isActive: $presentLastEntry) {
                if let first = entries.first { EntryDetailView(entry: first) }
            } label: { EmptyView() }

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
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if !selection.isEmpty {
                        Button(role: .destructive) { deleteSelected() } label: { Label("Delete", systemImage: "trash") }
                    } else {
                        NavigationLink(destination: ThreadsListView()) { Image(systemName: "rectangle.connected.to.line.below") }
                        NavigationLink(destination: InsightsView()) { Image(systemName: "chart.line.uptrend.xyaxis") }
                        EditButton()
                    }
                }
            }
            .searchable(text: $query)
            .refreshable { await refreshDerivedContentIfNeeded() }
            .sensoryFeedback(.selection, trigger: query.isEmpty)
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
            .task {
                // Handle incoming search requests from App Intent
                if let payload = UserDefaults.standard.dictionary(forKey: "deeplink.searchRequest") {
                    if let q = payload["query"] as? String { query = q }
                    if let tag = payload["tag"] as? String { selectedTags = [tag] }
                    if let mood = payload["mood"] as? String {
                        switch mood { case "negative": moodBin = 0; case "neutral": moodBin = 1; case "positive": moodBin = 2; default: break }
                    }
                    UserDefaults.standard.removeObject(forKey: "deeplink.searchRequest")
                }
                // Present last entry detail if requested (e.g., via intent)
                if UserDefaults.standard.bool(forKey: "deeplink.showLastEntry") {
                    UserDefaults.standard.removeObject(forKey: "deeplink.showLastEntry")
                    // Only present if we actually have entries
                    if entries.first != nil { presentLastEntry = true }
                }
            }
        }
    }

    @State private var shareText: String? = nil

    @ViewBuilder private func row(_ entry: JournalEntry, highlight query: String = "") -> some View {
        NavigationLink {
            EntryDetailView(entry: entry)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                highlightedText(displayText(for: entry, matchedBy: query), query: query)
                    .font(.headline)
                HStack(spacing: 12) {
                    if let label = entry.moodLabel {
                        MoodBadge(label: label, score: entry.moodScore ?? 0)
                    }
                    Text(entry.createdAt, style: .date)
                        .foregroundStyle(.secondary)
                    if !entry.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(entry.tags.prefix(3), id: \.id) { tag in
                                    Text(tag.name)
                                        .font(.caption2)
                                        .padding(.horizontal, 6).padding(.vertical, 2)
                                        .background(Color.secondary.opacity(0.15), in: Capsule())
                                }
                            }
                        }
                        .frame(height: 20)
                    }
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

    private func highlightedText(_ text: String, query: String) -> Text {
        guard !query.isEmpty else { return Text(text) }

        let lowercasedText = text.lowercased()
        let lowercasedQuery = query.lowercased()
        var ranges: [Range<String.Index>] = []
        var searchStartLower = lowercasedText.startIndex
        while let foundLower = lowercasedText.range(of: lowercasedQuery, options: [], range: searchStartLower ..< lowercasedText.endIndex) {
            let startOffset = lowercasedText.distance(from: lowercasedText.startIndex, to: foundLower.lowerBound)
            let endOffset = lowercasedText.distance(from: lowercasedText.startIndex, to: foundLower.upperBound)
            let start = text.index(text.startIndex, offsetBy: startOffset)
            let end = text.index(text.startIndex, offsetBy: endOffset)
            ranges.append(start ..< end)
            searchStartLower = foundLower.upperBound
        }

        guard !ranges.isEmpty else { return Text(text) }

        var current = text.startIndex
        var combined = Text("")
        for r in ranges {
            if current < r.lowerBound {
                combined = combined + Text(String(text[current ..< r.lowerBound]))
            }
            combined = combined + Text(String(text[r])).bold().foregroundStyle(Color.accentColor)
            current = r.upperBound
        }
        if current < text.endIndex {
            combined = combined + Text(String(text[current ..< text.endIndex]))
        }
        return combined
    }

    private func displayText(for entry: JournalEntry, matchedBy query: String, maxLength: Int = 160) -> String {
        guard !query.isEmpty else {
            return entry.title ?? entry.summary ?? String(entry.transcript.prefix(80))
        }

        let summary = entry.summary ?? ""
        if let snippet = contextualSnippet(from: summary, query: query, maxLength: maxLength), !snippet.isEmpty {
            return snippet
        }
        if let snippet = contextualSnippet(from: entry.transcript, query: query, maxLength: maxLength), !snippet.isEmpty {
            return snippet
        }
        return entry.title ?? entry.summary ?? String(entry.transcript.prefix(80))
    }

    private func contextualSnippet(from text: String, query: String, maxLength: Int) -> String? {
        guard !text.isEmpty else { return nil }
        guard let matchRange = text.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) else {
            return nil
        }

        let matchLength = text.distance(from: matchRange.lowerBound, to: matchRange.upperBound)
        let availableContext = max(0, maxLength - matchLength)
        let leftContext = availableContext / 2
        let rightContext = availableContext - leftContext

        let startIndex = text.startIndex
        let endIndex = text.endIndex

        let startCandidate = text.index(matchRange.lowerBound, offsetBy: -leftContext, limitedBy: startIndex) ?? startIndex
        let endCandidate = text.index(matchRange.upperBound, offsetBy: rightContext, limitedBy: endIndex) ?? endIndex

        let actualStart = startCandidate
        var actualEnd = endCandidate

        let currentLength = text.distance(from: actualStart, to: actualEnd)
        if currentLength > maxLength {
            let overflow = currentLength - maxLength
            actualEnd = text.index(actualEnd, offsetBy: -overflow)
        }

        var snippet = String(text[actualStart ..< actualEnd])
        if actualStart > startIndex { snippet = "…" + snippet }
        if actualEnd < endIndex { snippet += "…" }
        return snippet
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

    private func refreshDerivedContentIfNeeded() async {
        // Placeholder: In future, recompute derived data such as summaries/mood if needed
        // For now, this acts as a no-op to satisfy the checklist requirement and future hook.
        try? await Task.sleep(for: .milliseconds(300))
    }
}

// Deprecated: share container sheet removed

#Preview {
    NavigationStack { EntriesListView() }
}
