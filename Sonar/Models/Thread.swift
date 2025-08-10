import Foundation
import SwiftData

@Model
final class MemoryThread {
    @Attribute(.unique) var id: UUID
    var title: String
    @Relationship var entries: [JournalEntry] = []
    var createdAt: Date
    var updatedAt: Date

    init(id: UUID = .init(), title: String, createdAt: Date = .now) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        updatedAt = createdAt
    }
}
