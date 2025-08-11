import CoreSpotlight
import Foundation
import UniformTypeIdentifiers

struct DefaultSearchIndexingService: SearchIndexingService, Sendable {
    func index(entry: JournalEntry) async {
        // Respect user privacy preference to disable Spotlight indexing
        let enabled = UserDefaults.standard.object(forKey: "pref.spotlightIndexing") as? Bool ?? true
        guard enabled else { return }
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = entry.title ?? entry.summary ?? "Journal Entry"
        attributeSet.contentDescription = [entry.summary, entry.transcript, entry.notes].compactMap(\.self).joined(separator: "\n\n")
        attributeSet.keywords = entry.tags.map(\.name) + [entry.moodLabel].compactMap(\.self)
        let item = CSSearchableItem(uniqueIdentifier: entry.id.uuidString, domainIdentifier: "journal", attributeSet: attributeSet)
        try? await CSSearchableIndex.default().indexSearchableItems([item])
    }

    func deleteIndex(for id: UUID) async {
        try? await CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id.uuidString])
    }
}
