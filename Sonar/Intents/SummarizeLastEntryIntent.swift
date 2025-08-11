import AppIntents
import SwiftData
import SwiftUI

struct SummarizeLastEntryIntent: AppIntent {
    static var title: LocalizedStringResource = "Summarize Last Entry"
    static var description = IntentDescription("Regenerates a summary for your most recent journal entry.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        // Request app to open Journal tab and show last entry
        UserDefaults.standard.set(1, forKey: "deeplink.targetTab")
        UserDefaults.standard.set(true, forKey: "deeplink.showLastEntry")
        return .result()
    }
}
