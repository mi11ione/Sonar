import Foundation
import SwiftData

@Model
final class UserSettings {
    @Attribute(.unique) var id: UUID
    var hasCompletedOnboarding: Bool
    var iCloudSyncEnabled: Bool
    var dailyReminderHour: Int?
    var selectedPromptStyleId: UUID?
    var allowOnDeviceOnly: Bool
    // Text-to-speech preferences
    var ttsVoiceIdentifier: String?
    var ttsRate: Double
    var ttsPitch: Double
    // Insights preferences
    var weeklyInsightsEnabled: Bool
    // Spotlight indexing (privacy)
    var spotlightIndexingEnabled: Bool

    init(id: UUID = .init()) {
        self.id = id
        hasCompletedOnboarding = false
        iCloudSyncEnabled = false
        dailyReminderHour = nil
        selectedPromptStyleId = nil
        allowOnDeviceOnly = true
        ttsVoiceIdentifier = nil
        ttsRate = 0.5
        ttsPitch = 1.0
        weeklyInsightsEnabled = true
        spotlightIndexingEnabled = true
    }
}
