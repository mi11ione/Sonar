import AppIntents
import SwiftData
import SwiftUI

struct SummarizeLastEntryIntent: AppIntent {
    static var title: LocalizedStringResource = "Summarize Last Entry"
    static var description = IntentDescription("Regenerates a summary for your most recent journal entry.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        // Signal the app to handle the summarize action on next foreground if desired.
        // For now, just open the app; UI can provide a regenerate action.
        .result()
    }
}
