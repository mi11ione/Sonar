import StoreKit
import SwiftData
import SwiftUI

struct SearchFilterView: View {
    @Environment(\.purchases) private var purchases
    @State private var query = ""
    @State private var moodBin: Int? = nil
    @State private var datePreset: Int? = nil // 0: Today, 1: Last 7 days
    @State private var selectedTags: Set<String> = []
    @State private var selectedThreadId: UUID? = nil
    @State private var isSubscriber: Bool = false
    @State private var showPaywall: Bool = false
    @State private var plan: PurchasesPlan = .free
    @Query(sort: \MemoryThread.title) private var threads: [MemoryThread]

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
        .navigationTitle("nav_search")
        .toolbar { ToolbarItem(placement: .topBarTrailing) { filterMenu } }
        .searchable(text: $query)
        .overlay {
            if entries.isEmpty {
                ContentUnavailableView("no_entries_yet", systemImage: "mic", description: Text("record_to_start_journal"))
            } else if filtered(entries).isEmpty, !query.isEmpty {
                ContentUnavailableView("no_results", systemImage: "magnifyingglass", description: Text("try_broadening_or_clear_filters"))
            }
        }
        .task { plan = await purchases.currentPlan() }
        .task { isSubscriber = await purchases.isSubscriber() }
        .sheet(isPresented: $showPaywall) { PaywallView(source: "search") }
    }

    private var filterMenu: some View {
        Menu {
            Picker("filter_mood", selection: $moodBin) {
                Text("any").tag(Int?.none)
                Text("negative").tag(Optional(0))
                Text("neutral").tag(Optional(1))
                Text("positive").tag(Optional(2))
            }
            Picker("filter_date", selection: $datePreset) {
                Text("any").tag(Int?.none)
                Text("today").tag(Optional(0))
                Text("last_7_days").tag(Optional(1))
            }
            Menu("filter_tags") {
                let allTags: [String] = Array(Set(entries.flatMap { $0.tags.map(\.name) })).sorted()
                ForEach(allTags, id: \.self) { tagName in
                    Button {
                        if selectedTags.contains(tagName) { selectedTags.remove(tagName) } else { selectedTags.insert(tagName) }
                    } label: {
                        HStack { Text(tagName); Spacer(); if selectedTags.contains(tagName) { Image(systemName: "checkmark") } }
                    }
                }
            }
            Picker("filter_thread", selection: $selectedThreadId) {
                Text("any").tag(UUID?.none)
                ForEach(threads) { thread in
                    Text(thread.title).tag(Optional(thread.id))
                }
            }
            Divider()
            Button {
                if !isSubscriber { showPaywall = true }
            } label: {
                Label("Advanced filters (Premium)", systemImage: "lock")
            }
            .disabled(isSubscriber)
            Button("clear_filters") { moodBin = nil; datePreset = nil; selectedTags.removeAll() }
        } label: {
            Label("filters", systemImage: "line.3.horizontal.decrease.circle")
        }
    }

    private func filtered(_ all: [JournalEntry]) -> [JournalEntry] {
        let range: ClosedRange<Date>? = switch datePreset {
        case 0: Calendar.current.startOfDay(for: .now) ... Date()
        case 1: Calendar.current.date(byAdding: .day, value: -7, to: .now)! ... Date()
        default: nil
        }
        let entRange: ClosedRange<Date>? = switch plan {
        case .free: Calendar.current.date(byAdding: .day, value: -7, to: .now)! ... Date()
        case .pro: Calendar.current.date(byAdding: .day, value: -30, to: .now)! ... Date()
        case .premium, .lifetime: nil
        }
        return all.filter { entry in
            var include = true
            if !query.isEmpty {
                let text = entry.transcript + "\n" + (entry.summary ?? "")
                include = include && text.localizedCaseInsensitiveContains(query)
            }
            if let moodBin { include = include && moodMatches(entry.moodScore, bin: moodBin) }
            if let range { include = include && range.contains(entry.createdAt) }
            if let entRange { include = include && entRange.contains(entry.createdAt) }
            if !selectedTags.isEmpty { include = include && !Set(entry.tags.map(\.name)).intersection(selectedTags).isEmpty }
            if let threadId = selectedThreadId {
                include = include && threads.first(where: { $0.id == threadId })?.entries.contains(where: { $0.id == entry.id }) == true
            }
            return include
        }
    }

    private func moodMatches(_ score: Double?, bin: Int) -> Bool {
        guard let s = score else { return false }
        switch bin { case 0: return s < -0.2; case 1: return abs(s) <= 0.2; case 2: return s > 0.2; default: return true }
    }
}

#Preview { NavigationStack { SearchFilterView() } }
