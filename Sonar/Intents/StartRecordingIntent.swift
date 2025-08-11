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

// MARK: - Spotlight-suggestible App Shortcuts

struct SonarAppShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .blue
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: StartRecordingIntent(),
                phrases: ["Start recording in \(.applicationName)"],
                shortTitle: "Start Recording",
                systemImageName: "mic.fill"
            ),
            AppShortcut(
                intent: SummarizeLastEntryIntent(),
                phrases: ["Summarize last entry in \(.applicationName)"],
                shortTitle: "Summarize Last",
                systemImageName: "text.alignleft"
            ),
            AppShortcut(
                intent: SearchEntriesIntent(),
                phrases: ["Search entries in \(.applicationName)"],
                shortTitle: "Search Entries",
                systemImageName: "magnifyingglass"
            ),
        ]
    }
}
