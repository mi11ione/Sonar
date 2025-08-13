import AppIntents

struct StopRecordingIntent: AppIntent {
    static var title: LocalizedStringResource = "stop_recording"
    static var description = IntentDescription("intent_stop_recording_desc")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(true, forKey: "deeplink.startRecording")
        UserDefaults.standard.set(true, forKey: "deeplink.stopNow")
        if let d = UserDefaults(suiteName: "group.com.mi11ion.Sonar") {
            d.set(true, forKey: "deeplink.startRecording")
            d.set(true, forKey: "deeplink.stopNow")
        }
        return .result()
    }
}
