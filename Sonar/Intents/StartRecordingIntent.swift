import AppIntents
import Foundation

struct StartRecordingIntent: AppIntent {
    static var title: LocalizedStringResource = "start_recording"
    static var description = IntentDescription("intent_start_recording_desc")
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(true, forKey: "deeplink.startRecording")
        if let d = UserDefaults(suiteName: "group.com.mi11ion.Sonar") {
            d.set(true, forKey: "deeplink.startRecording")
        }
        // When invoked from a widget/Live Activity, presenting a dialog is unsupported and can assert.
        // Open the app (per openAppWhenRun) and let the app handle UI.
        return .result()
    }
}

// MARK: - Spotlight-suggestible App Shortcuts

struct SonarAppShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .blue
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: StartRecordingIntent(),
                phrases: ["start_recording_app \(.applicationName)"],
                shortTitle: "start_recording",
                systemImageName: "mic.fill"
            ),
            AppShortcut(
                intent: SummarizeLastEntryIntent(),
                phrases: ["summarize_last_in_app \(.applicationName)"],
                shortTitle: "summarize_last_entry",
                systemImageName: "text.alignleft"
            ),
            AppShortcut(
                intent: SearchEntriesIntent(),
                phrases: ["search_entries_in_app \(.applicationName)"],
                shortTitle: "search_entries",
                systemImageName: "magnifyingglass"
            ),
        ]
    }
}
