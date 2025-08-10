import Foundation
import SwiftData

@Model
final class PromptStyle {
    @Attribute(.unique) var id: UUID
    var displayName: String
    var maxSentences: Int
    var includeActionItems: Bool
    var toneHint: String?
    var isPremium: Bool

    init(
        id: UUID = .init(),
        displayName: String,
        maxSentences: Int = 3,
        includeActionItems: Bool = false,
        toneHint: String? = nil,
        isPremium: Bool = false
    ) {
        self.id = id
        self.displayName = displayName
        self.maxSentences = maxSentences
        self.includeActionItems = includeActionItems
        self.toneHint = toneHint
        self.isPremium = isPremium
    }
}
