import Foundation
import NaturalLanguage

struct DefaultMoodAnalysisService: MoodAnalysisService, Sendable {
    func analyze(text: String) async -> (score: Double, label: String) {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        let score = Double(sentiment?.rawValue ?? "0") ?? 0
        let label = if score < -0.2 { String(localized: "negative") }
        else if score > 0.2 { String(localized: "positive") }
        else { String(localized: "neutral") }
        return (score, label)
    }
}
