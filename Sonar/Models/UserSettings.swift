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

    init(id: UUID = .init()) {
        self.id = id
        hasCompletedOnboarding = false
        iCloudSyncEnabled = false
        dailyReminderHour = nil
        selectedPromptStyleId = nil
        allowOnDeviceOnly = true
    }
}
