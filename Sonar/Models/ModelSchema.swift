import SwiftData

enum ModelSchemas {
    static let fullLocal = Schema([
        JournalEntry.self,
        AudioAsset.self,
        Tag.self,
        PromptStyle.self,
        UserSettings.self,
        MemoryThread.self,
    ])

    static let cloud = Schema([
        JournalEntry.self,
        Tag.self,
        PromptStyle.self,
        UserSettings.self,
        MemoryThread.self,
    ])
}
