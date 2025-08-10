import Foundation

protocol SearchIndexingService: Sendable {
    func index(entry: JournalEntry) async
    func deleteIndex(for id: UUID) async
}
