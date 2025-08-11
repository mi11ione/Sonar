import Foundation

struct WeeklyInsights: Sendable {
    let topThemes: [String]
    let avgMood: Double?
    let highlightSummaries: [String]
}

protocol InsightsService: Sendable {
    func computeWeeklyInsights(from entries: [JournalEntry]) async -> WeeklyInsights
}

struct DefaultInsightsService: InsightsService, Sendable {
    func computeWeeklyInsights(from entries: [JournalEntry]) async -> WeeklyInsights {
        let recent = entries.filter { Calendar.current.isDate($0.createdAt, equalTo: Date(), toGranularity: .weekOfYear) }
        let tokens = recent.flatMap { $0.tags.map(\.name) }
        let freq = Dictionary(grouping: tokens, by: { $0 }).mapValues(\.count)
        let topThemes = Array(freq.sorted { $0.value > $1.value }.prefix(3).map(\.key))
        let moods = recent.compactMap(\.moodScore)
        let avgMood = moods.isEmpty ? nil : moods.reduce(0, +) / Double(moods.count)
        let highlights = recent.compactMap(\.summary).prefix(5)
        return WeeklyInsights(topThemes: topThemes, avgMood: avgMood, highlightSummaries: Array(highlights))
    }
}
