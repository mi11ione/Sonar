import SwiftData
import SwiftUI

struct InsightsView: View {
    @Environment(\.insights) private var insights
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @State private var weekly: WeeklyInsights = .init(topThemes: [], avgMood: nil, highlightSummaries: [])
    var body: some View {
        List {
            Section("Top themes") {
                if weekly.topThemes.isEmpty { Text("No themes yet") } else { ForEach(weekly.topThemes, id: \.self, content: Text.init) }
            }
            Section("Average mood") {
                if let m = weekly.avgMood { Text(String(format: "%.2f", m)) } else { Text("–") }
            }
            Section("Highlights") {
                if weekly.highlightSummaries.isEmpty { Text("No highlights yet") } else { ForEach(weekly.highlightSummaries, id: \.self, content: Text.init) }
            }
        }
        .navigationTitle("Insights")
        .task { weekly = await insights.computeWeeklyInsights(from: entries) }
    }
}

#Preview { NavigationStack { InsightsView() } }
