import Foundation

/// Bridges recent data from the app to widgets via shared defaults.
/// In production, configure an App Group and use the suite name below.
actor WidgetBridge {
    static let shared = WidgetBridge()

    private let suiteName = "group.com.mi11ion.Sonar"

    func updateRecentSummary(entry: JournalEntry) {
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        defaults.set(entry.summary ?? String(entry.transcript.prefix(120)), forKey: "widget.lastSummary")
        defaults.set(entry.moodLabel ?? "", forKey: "widget.lastMood")
        defaults.set(entry.createdAt.timeIntervalSince1970, forKey: "widget.lastDate")
    }

    func setLastSaveDate(_ date: Date) {
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        defaults.set(date.timeIntervalSince1970, forKey: "widget.lastSave")
    }
}
