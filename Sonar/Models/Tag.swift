import Foundation
import SwiftData

@Model
final class Tag {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String

    @Relationship var entries: [JournalEntry] = []

    init(id: UUID = .init(), name: String) {
        self.id = id
        self.name = name
    }
}
