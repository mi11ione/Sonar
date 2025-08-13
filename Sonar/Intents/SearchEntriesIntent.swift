import AppIntents
import Foundation

struct SearchEntriesIntent: AppIntent {
    static var title: LocalizedStringResource = "search_entries"
    static var description = IntentDescription("intent_search_entries_desc")
    static var openAppWhenRun: Bool = true

    @Parameter(title: "query") var query: String?
    @Parameter(title: "mood", default: .any) var mood: MoodBin
    @Parameter(title: "tag") var tag: String?

    enum MoodBin: String, AppEnum, CaseDisplayRepresentable {
        case any, negative, neutral, positive
        static var typeDisplayRepresentation: TypeDisplayRepresentation { "mood" }
        static var caseDisplayRepresentations: [MoodBin: DisplayRepresentation] = [
            .any: "any", .negative: "negative", .neutral: "neutral", .positive: "positive",
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
        if let d = UserDefaults(suiteName: "group.com.mi11ion.Sonar") {
            d.set(payload, forKey: "deeplink.searchRequest")
            d.set(1, forKey: "deeplink.targetTab")
        }
        return .result()
    }
}
