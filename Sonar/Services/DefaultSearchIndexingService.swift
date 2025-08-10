import CoreSpotlight
import Foundation
import UniformTypeIdentifiers

struct DefaultSearchIndexingService: SearchIndexingService, Sendable {
    func index(entry: JournalEntry) async {
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = entry.summary ?? "Journal Entry"
        // Provide richer, full-text material for Spotlight to match anywhere in the entry
        // Put summary first to boost relevance, then the full transcript
        attributeSet.contentDescription = [entry.summary, entry.transcript].compactMap(\.self).joined(separator: "\n\n")
        attributeSet.keywords = entry.tags.map(\.name) + [entry.moodLabel].compactMap(\.self)
        let item = CSSearchableItem(uniqueIdentifier: entry.id.uuidString, domainIdentifier: "journal", attributeSet: attributeSet)
        try? await CSSearchableIndex.default().indexSearchableItems([item])
    }

    func deleteIndex(for id: UUID) async {
        try? await CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id.uuidString])
    }
}
