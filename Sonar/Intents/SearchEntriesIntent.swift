import AppIntents
import Foundation

struct SearchEntriesIntent: AppIntent {
    static var title: LocalizedStringResource = "Search Entries"
    static var description = IntentDescription("Search your entries by text, tag, or mood.")
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Query") var query: String?
    @Parameter(title: "Mood", default: .any) var mood: MoodBin
    @Parameter(title: "Tag") var tag: String?

    enum MoodBin: String, AppEnum, CaseDisplayRepresentable {
        case any, negative, neutral, positive
        static var typeDisplayRepresentation: TypeDisplayRepresentation { "Mood" }
        static var caseDisplayRepresentations: [MoodBin: DisplayRepresentation] = [
            .any: "Any", .negative: "Negative", .neutral: "Neutral", .positive: "Positive",
        ]
    }

    func perform() async throws -> some IntentResult {
        // Persist a simple request for the UI to open Journal and pre-fill filters
        var payload: [String: Any] = [:]
        if let q = query, !q.isEmpty { payload["query"] = q }
        if let t = tag, !t.isEmpty { payload["tag"] = t }
        payload["mood"] = mood.rawValue
        UserDefaults.standard.set(payload, forKey: "deeplink.searchRequest")
        UserDefaults.standard.set(1, forKey: "deeplink.targetTab") // Journal tab
        return .result()
    }
}
