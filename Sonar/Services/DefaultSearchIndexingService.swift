import CoreSpotlight
import Foundation
import OSLog
import UniformTypeIdentifiers

// Coalesces indexing requests to avoid spamming CSSearchableIndex.
private struct SearchIndexRecord {
    let id: String
    let title: String
    let contentDescription: String
    let keywords: [String]
}

private actor SearchIndexBatcher {
    private var pending: [String: SearchIndexRecord] = [:]
    private var flushTask: Task<Void, Never>?

    func add(_ record: SearchIndexRecord) {
        pending[record.id] = record
        scheduleFlushIfNeeded()
    }

    private func scheduleFlushIfNeeded() {
        guard flushTask == nil else { return }
        flushTask = Task { [weak self] in
            // Short debounce window to batch bursts
            try? await Task.sleep(for: .milliseconds(500))
            await self?.flush()
        }
    }

    private func flush() {
        let records = pending
        pending.removeAll()
        flushTask = nil

        guard !records.isEmpty else { return }
        var items: [CSSearchableItem] = []
        items.reserveCapacity(records.count)
        for (_, r) in records {
            let attr = CSSearchableItemAttributeSet(contentType: .text)
            attr.title = r.title
            attr.contentDescription = r.contentDescription
            attr.keywords = r.keywords
            items.append(CSSearchableItem(uniqueIdentifier: r.id, domainIdentifier: "journal", attributeSet: attr))
        }
        Task.detached {
            do { try await CSSearchableIndex.default().indexSearchableItems(items) }
            catch { await Logger.perf.error("Batch indexing failed: \(error.localizedDescription, privacy: .public)") }
        }
    }
}

private enum IndexingShared { static let batcher = SearchIndexBatcher() }

struct DefaultSearchIndexingService: SearchIndexingService, Sendable {
    func index(entry: JournalEntry) async {
        // Respect user privacy preference to disable Spotlight indexing
        let enabled = UserDefaults.standard.object(forKey: "pref.spotlightIndexing") as? Bool ?? true
        guard enabled else { return }
        let record = SearchIndexRecord(
            id: entry.id.uuidString,
            title: entry.title ?? entry.summary ?? String(localized: "journal_entry"),
            contentDescription: [entry.summary, entry.transcript, entry.notes].compactMap(\.self).joined(separator: "\n\n"),
            keywords: entry.tags.map(\.name) + [entry.moodLabel].compactMap(\.self)
        )
        await IndexingShared.batcher.add(record)
    }

    func deleteIndex(for id: UUID) async {
        do {
            try await CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id.uuidString])
            Logger.perf.log("Deleted index for \(id.uuidString, privacy: .public)")
        } catch {
            Logger.perf.error("Index delete failed: \(error.localizedDescription, privacy: .public)")
        }
    }
}
