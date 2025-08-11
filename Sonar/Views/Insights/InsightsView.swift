import SwiftData
import SwiftUI

struct InsightsView: View {
    @Environment(\.insights) private var insights
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @State private var weekly: WeeklyInsights = .init(topThemes: [], avgMood: nil, highlightSummaries: [])
    @State private var lastFourWeeks: [[JournalEntry]] = []
    var body: some View {
        List {
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
            }
        }
        .navigationTitle("Insights")
        .task {
            weekly = await insights.computeWeeklyInsights(from: entries)
            lastFourWeeks = groupLastFourWeeks(entries)
        }
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
