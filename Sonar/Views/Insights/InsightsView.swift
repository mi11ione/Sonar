import SwiftData
import SwiftUI

struct InsightsView: View {
    @Environment(\.insights) private var insights
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @Query private var settingsRows: [UserSettings]
    @State private var weekly: WeeklyInsights = .init(topThemes: [], avgMood: nil, highlightSummaries: [])
    @State private var lastFourWeeks: [[JournalEntry]] = []
    var body: some View {
        List {
            Section("Privacy") {
                Text("Insights are computed on your device. No summaries or transcripts leave your phone.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Section("Top themes") {
                if weekly.topThemes.isEmpty { Text("No themes yet") } else { ForEach(weekly.topThemes, id: \.self, content: Text.init) }
            }
            Section("Average mood") {
                if let m = weekly.avgMood { Text(String(format: "%.2f", m)) } else { Text("–") }
            }
            Section("Mood trend") {
                Sparkline(values: moodAverages(lastFourWeeks))
                    .frame(height: 44)
                    .foregroundStyle(.blue)
            }
            Section("Highlights") {
                if weekly.highlightSummaries.isEmpty { Text("No highlights yet") } else { ForEach(weekly.highlightSummaries, id: \.self, content: Text.init) }
                if !weekly.highlightSummaries.isEmpty {
                    let header = "This week’s Sonar highlights (private)\n\n"
                    let content = weekly.highlightSummaries.map { "• \($0)" }.joined(separator: "\n")
                    let range = dateRangeOfCurrentWeek()
                    let title = range.map { "\($0.0) – \($0.1)" } ?? "This week"
                    let payload = "\(title)\n\n" + header + content
                    ShareLink(item: payload) { Label("Share weekly highlights", systemImage: "square.and.arrow.up") }
                        .buttonStyle(.bordered)
                }
            }
            Section("Suggested prompts") {
                Text("What energized you this week? What drained you?")
                Text("What small win are you proud of?")
                Text("What trend do you notice in your mood?")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Insights")
        .task { await computeIfEnabled() }
        .refreshable { await computeIfEnabled() }
    }
}

#Preview { NavigationStack { InsightsView() } }

// MARK: - Lightweight sparkline

private struct Sparkline: View {
    var values: [Double]
    var body: some View {
        GeometryReader { geo in
            let points = makePoints(in: geo.size)
            Path { p in
                guard let first = points.first else { return }
                p.move(to: first)
                for pt in points.dropFirst() {
                    p.addLine(to: pt)
                }
            }
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }

    private func makePoints(in size: CGSize) -> [CGPoint] {
        guard !values.isEmpty else { return [] }
        let minV = values.min() ?? 0
        let maxV = values.max() ?? 1
        let span = max(maxV - minV, 0.001)
        let stepX = values.count > 1 ? size.width / CGFloat(values.count - 1) : 0
        return values.enumerated().map { idx, v in
            let x = CGFloat(idx) * stepX
            // map mood [-1,1] to y (0..1) then to canvas (invert for y-up)
            let normalized = (v - minV) / span
            let y = size.height * (1 - CGFloat(normalized))
            return CGPoint(x: x, y: y)
        }
    }
}

private func groupLastFourWeeks(_ entries: [JournalEntry]) -> [[JournalEntry]] {
    let cal = Calendar.current
    let now = Date()
    return (0 ..< 4).map { offset in
        let weekStart = cal.date(byAdding: .weekOfYear, value: -offset, to: now)!
        return entries.filter { cal.isDate($0.createdAt, equalTo: weekStart, toGranularity: .weekOfYear) }
    }.reversed()
}

private func moodAverages(_ weeks: [[JournalEntry]]) -> [Double] {
    weeks.map { week in
        let moods = week.compactMap(\.moodScore)
        guard !moods.isEmpty else { return 0 }
        return moods.reduce(0, +) / Double(moods.count)
    }
}

private extension InsightsView {
    @MainActor
    func computeIfEnabled() async {
        let enabled = settingsRows.first?.weeklyInsightsEnabled ?? true
        guard enabled else {
            weekly = .init(topThemes: [], avgMood: nil, highlightSummaries: [])
            lastFourWeeks = []
            return
        }
        weekly = await insights.computeWeeklyInsights(from: entries)
        lastFourWeeks = groupLastFourWeeks(entries)
    }

    func dateRangeOfCurrentWeek() -> (String, String)? {
        let cal = Calendar.current
        let now = Date()
        guard let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else { return nil }
        let end = cal.date(byAdding: .day, value: 6, to: start) ?? now
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .none
        return (fmt.string(from: start), fmt.string(from: end))
    }
}
