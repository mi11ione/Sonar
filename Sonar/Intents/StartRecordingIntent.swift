import AppIntents
import Foundation

struct StartRecordingIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Recording"
    static var description = IntentDescription("Begin a new voice journal entry.")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(true, forKey: "deeplink.startRecording")
        return .result(dialog: IntentDialog("Starting recording…"))
    }
}
