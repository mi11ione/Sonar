import Foundation

struct DefaultSearchIndexingService: SearchIndexingService, Sendable {
    func index(entry _: JournalEntry) async { /* no-op for now */ }
    func deleteIndex(for _: UUID) async { /* no-op for now */ }
}
