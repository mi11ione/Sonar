import SwiftData
import SwiftUI

struct SearchFilterView: View {
    @State private var query: String = ""
    @State private var moodBin: Int? = nil
    @State private var dateRange: ClosedRange<Date>? = nil
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @State private var showCustomDates: Bool = false
    @State private var customStart: Date = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
    @State private var customEnd: Date = .now

    var body: some View {
        List(filtered(entries), id: \.id) { entry in
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
        .searchable(text: $query)
        .navigationTitle("Search")
        .toolbar {
            Menu {
                Picker("Mood", selection: $moodBin) {
                    Text("Any").tag(Int?.none)
                    Text("Negative").tag(Optional(0))
                    Text("Neutral").tag(Optional(1))
                    Text("Positive").tag(Optional(2))
                }
                Button("Today") { dateRange = Calendar.current.startOfDay(for: .now) ... Date() }
                Button("Last 7 days") { dateRange = Calendar.current.date(byAdding: .day, value: -7, to: .now)! ... Date() }
                Button("Custom range…") { showCustomDates = true }
                Button("Clear filters") { moodBin = nil; dateRange = nil }
            } label: {
                Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
            }
        }
        .sheet(isPresented: $showCustomDates) {
            NavigationStack {
                Form {
                    DatePicker("Start", selection: $customStart, displayedComponents: [.date])
                    DatePicker("End", selection: $customEnd, displayedComponents: [.date])
                }
                .navigationTitle("Custom Dates")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Apply") {
                            dateRange = Calendar.current.startOfDay(for: customStart) ... customEnd
                            showCustomDates = false
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) { Button("Cancel") { showCustomDates = false } }
                }
            }
        }
    }

    private func filtered(_ all: [JournalEntry]) -> [JournalEntry] {
        all.filter { entry in
            var include = true
            if !query.isEmpty {
                let text = entry.transcript + "\n" + (entry.summary ?? "")
                include = include && text.localizedCaseInsensitiveContains(query)
            }
            if let moodBin { include = include && moodMatches(entry.moodScore, bin: moodBin) }
            if let dateRange { include = include && dateRange.contains(entry.createdAt) }
            return include
        }
    }

    private func moodMatches(_ score: Double?, bin: Int) -> Bool {
        guard let score else { return false }
        switch bin {
        case 0: return score < -0.2
        case 1: return abs(score) <= 0.2
        case 2: return score > 0.2
        default: return true
        }
    }
}

#Preview {
    NavigationStack { SearchFilterView() }
}
