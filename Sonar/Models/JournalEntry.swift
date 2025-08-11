import Foundation
import SwiftData

@Model
final class JournalEntry: @unchecked Sendable {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var sortRank: Double

    // Optional user-provided metadata
    var title: String?
    var notes: String?

    var transcript: String
    var summary: String?

    var moodScore: Double?
    var moodLabel: String?

    @Relationship(deleteRule: .cascade) var audio: AudioAsset?
    @Relationship(inverse: \Tag.entries) var tags: [Tag] = []

    var isPinned: Bool

    init(id: UUID = .init(), createdAt: Date = .now, transcript: String) {
        self.id = id
        self.createdAt = createdAt
        updatedAt = createdAt
        sortRank = createdAt.timeIntervalSinceReferenceDate
        self.transcript = transcript
        isPinned = false
    }
}
