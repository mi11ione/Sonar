import AppIntents

struct TogglePauseRecordingIntent: AppIntent {
    static var title: LocalizedStringResource = "pause_resume"
    static var description = IntentDescription("intent_pause_resume_desc")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(true, forKey: "deeplink.startRecording")
        UserDefaults.standard.set(true, forKey: "deeplink.togglePause")
        return .result()
    }
}
