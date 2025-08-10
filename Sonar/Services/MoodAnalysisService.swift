import Foundation

protocol MoodAnalysisService: Sendable {
    func analyze(text: String) async -> (score: Double, label: String)
}
