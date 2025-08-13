import AppIntents
import SwiftData
import SwiftUI

struct SummarizeLastEntryIntent: AppIntent {
    static var title: LocalizedStringResource = "summarize_last_entry"
    static var description = IntentDescription("intent_summarize_last_desc")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        // Request app to open Journal tab and show last entry
        UserDefaults.standard.set(1, forKey: "deeplink.targetTab")
        UserDefaults.standard.set(true, forKey: "deeplink.showLastEntry")
        if let d = UserDefaults(suiteName: "group.com.mi11ion.Sonar") {
            d.set(1, forKey: "deeplink.targetTab")
            d.set(true, forKey: "deeplink.showLastEntry")
        }
        return .result()
    }
}
