import Foundation
import CoreSpotlight
import UniformTypeIdentifiers

struct DefaultSearchIndexingService: SearchIndexingService, Sendable {
    func index(entry: JournalEntry) async {
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = entry.summary ?? "Journal Entry"
        attributeSet.contentDescription = String(entry.transcript.prefix(200))
        attributeSet.keywords = entry.tags.map { $0.name } + [entry.moodLabel].compactMap { $0 }
        let item = CSSearchableItem(uniqueIdentifier: entry.id.uuidString, domainIdentifier: "journal", attributeSet: attributeSet)
        try? await CSSearchableIndex.default().indexSearchableItems([item])
    }

    func deleteIndex(for id: UUID) async {
        try? await CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id.uuidString])
    }
}
