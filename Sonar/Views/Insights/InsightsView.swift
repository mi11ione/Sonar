import OSLog
import StoreKit
import SwiftData
import SwiftUI

struct InsightsView: View {
    @Environment(\.insights) private var insights
    @Environment(\.purchases) private var purchases
    @Query(sort: \JournalEntry.createdAt, order: .reverse) private var entries: [JournalEntry]
    @Query private var settingsRows: [UserSettings]
    @State private var weekly: WeeklyInsights = .init(topThemes: [], avgMood: nil, highlightSummaries: [])
    @State private var lastFourWeeks: [[JournalEntry]] = []
    @State private var isSubscriber: Bool = false
    @State private var showPaywall: Bool = false
    @State private var plan: PurchasesPlan = .free
    var body: some View {
        List {
            Section("privacy") {
                Text("insights_privacy_copy")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Section("top_themes") { section(requiredPlan: .pro) { if weekly.topThemes.isEmpty { Text("no_themes_yet") } else { ForEach(weekly.topThemes, id: \.self, content: Text.init) } } }
            Section("average_mood") { section(requiredPlan: .premium) { if let m = weekly.avgMood { Text(String(format: "%.2f", m)) } else { Text("dash_placeholder") } } }
            Section("mood_trend") { section(requiredPlan: .premium) { Sparkline(values: moodAverages(lastFourWeeks)).frame(height: 44).foregroundStyle(.blue) } }
            Section("highlights") {
                section(requiredPlan: .premium) {
                    if weekly.highlightSummaries.isEmpty { Text("no_highlights_yet") } else { ForEach(weekly.highlightSummaries, id: \.self, content: Text.init) }
                    if !weekly.highlightSummaries.isEmpty {
                        let header = String(localized: "weekly_highlights_header")
                        let content = weekly.highlightSummaries.map { "• \($0)" }.joined(separator: "\n")
                        let range = dateRangeOfCurrentWeek()
                        let title = range.map { "\($0.0) – \($0.1)" } ?? String(localized: "this_week")
                        let payload = "\(title)\n\n" + header + content
                        ShareLink(item: payload) { Label("share_weekly_highlights", systemImage: "square.and.arrow.up") }
                            .buttonStyle(.bordered)
                    }
                }
            }
            Section("suggested_prompts") {
                Text("prompt_week_energized_drained")
                Text("prompt_week_small_win")
                Text("prompt_week_trend")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("nav_insights")
        .task { await hydrateEntitlements(); await computeIfEnabled(); Logger.purchase.log("insights_viewed") }
        .refreshable { await hydrateEntitlements(); await computeIfEnabled() }
        .sheet(isPresented: $showPaywall) { PaywallView(source: "insights") }
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
    func hydrateEntitlements() async {
        isSubscriber = await purchases.isSubscriber()
        plan = await purchases.currentPlan()
    }

    @ViewBuilder
    func section(requiredPlan: PurchasesPlan, @ViewBuilder content: () -> some View) -> some View {
        let allowed: Bool = switch requiredPlan {
        case .free: true
        case .pro: plan == .pro || plan == .premium || plan == .lifetime
        case .premium, .lifetime: plan == .premium || plan == .lifetime
        }
        if allowed {
            content()
        } else {
            VStack(alignment: .leading, spacing: 6) {
                Rectangle().fill(Color.secondary.opacity(0.15)).frame(height: 32).cornerRadius(6)
                Text("Unlock Premium to see more insights.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Button("Unlock Premium") { showPaywall = true }
                    .buttonStyle(.borderedProminent)
            }
        }
    }

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
