import Foundation

protocol SummarizationService: Sendable {
    func summarize(text: String, maxSentences: Int, toneHint: String?) async -> String
}
