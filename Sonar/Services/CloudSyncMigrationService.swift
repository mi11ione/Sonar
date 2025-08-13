import Foundation
import OSLog
import SwiftData

/// Performs one-time migration of local records into the CloudKit-backed container.
/// Excludes `AudioAsset` per v1 scope and preserves UUIDs and relationships.
struct CloudSyncMigrationService: Sendable {
    struct Progress: Sendable { let total: Int; let migrated: Int }
    final class CancellationToken: @unchecked Sendable { private(set) var isCancelled = false; func cancel() { isCancelled = true } }

    private let logger = Logger.sync

    /// Migrates data from `source` to `destination` container.
    /// Returns an AsyncStream of progress updates.
    @MainActor
    func migrate(from source: ModelContainer, to destination: ModelContainer, token: CancellationToken? = nil) -> AsyncStream<Progress> {
        AsyncStream { continuation in
            Task {
                logger.log("sync_migrate_started")
                let sourceContext = ModelContext(source)
                let destContext = ModelContext(destination)

                // Fetch all models from source
                let allEntries: [JournalEntry] = (try? sourceContext.fetch(FetchDescriptor<JournalEntry>())) ?? []
                let allTags: [Tag] = (try? sourceContext.fetch(FetchDescriptor<Tag>())) ?? []
                let allThreads: [MemoryThread] = (try? sourceContext.fetch(FetchDescriptor<MemoryThread>())) ?? []
                let allStyles: [PromptStyle] = (try? sourceContext.fetch(FetchDescriptor<PromptStyle>())) ?? []
                let allSettings: [UserSettings] = (try? sourceContext.fetch(FetchDescriptor<UserSettings>())) ?? []

                // Pre-insert static-like tables first (styles), then tags/threads, then entries
                var migratedCount = 0
                let total = allStyles.count + allTags.count + allThreads.count + allEntries.count + allSettings.count
                let chunkSize = 200

                // Styles
                if token?.isCancelled == true { continuation.finish(); return }
                for style in allStyles {
                    upsert(style, into: destContext)
                }
                try? destContext.save()
                migratedCount += allStyles.count
                continuation.yield(.init(total: total, migrated: migratedCount))

                // Tags
                if token?.isCancelled == true { continuation.finish(); return }
                for tag in allTags {
                    upsert(tag, into: destContext)
                }
                try? destContext.save()
                migratedCount += allTags.count
                continuation.yield(.init(total: total, migrated: migratedCount))

                // Threads (without entries first)
                if token?.isCancelled == true { continuation.finish(); return }
                for thread in allThreads {
                    upsert(thread, into: destContext, includeEntries: false)
                }
                try? destContext.save()
                migratedCount += allThreads.count
                continuation.yield(.init(total: total, migrated: migratedCount))

                // Entries (without audio)
                var buffer: [JournalEntry] = []
                buffer.reserveCapacity(chunkSize)
                for entry in allEntries {
                    if token?.isCancelled == true { continuation.finish(); return }
                    let copy = JournalEntry(id: entry.id, createdAt: entry.createdAt, transcript: entry.transcript)
                    copy.updatedAt = entry.updatedAt
                    copy.sortRank = entry.sortRank
                    copy.title = entry.title
                    copy.notes = entry.notes
                    copy.summary = entry.summary
                    copy.moodScore = entry.moodScore
                    copy.moodLabel = entry.moodLabel
                    copy.isPinned = entry.isPinned
                    // Relationships will be re-linked after inserts
                    buffer.append(copy)
                    if buffer.count >= chunkSize {
                        for e in buffer {
                            destContext.insert(e)
                        }
                        try? destContext.save()
                        migratedCount += buffer.count
                        continuation.yield(.init(total: total, migrated: migratedCount))
                        buffer.removeAll(keepingCapacity: true)
                    }
                }
                if !buffer.isEmpty {
                    for e in buffer {
                        destContext.insert(e)
                    }
                    try? destContext.save()
                    migratedCount += buffer.count
                    continuation.yield(.init(total: total, migrated: migratedCount))
                }

                // Rebuild relationships (tags, threads → entries). Use unions to avoid duplicates.
                // Build lookups in destination
                if token?.isCancelled == true { continuation.finish(); return }
                let destEntries: [UUID: JournalEntry] = {
                    let arr: [JournalEntry] = (try? destContext.fetch(FetchDescriptor<JournalEntry>())) ?? []
                    return Dictionary(uniqueKeysWithValues: arr.map { ($0.id, $0) })
                }()
                let destTags: [UUID: Tag] = {
                    let arr: [Tag] = (try? destContext.fetch(FetchDescriptor<Tag>())) ?? []
                    return Dictionary(uniqueKeysWithValues: arr.map { ($0.id, $0) })
                }()
                let destThreads: [UUID: MemoryThread] = {
                    let arr: [MemoryThread] = (try? destContext.fetch(FetchDescriptor<MemoryThread>())) ?? []
                    return Dictionary(uniqueKeysWithValues: arr.map { ($0.id, $0) })
                }()

                for tag in allTags {
                    if token?.isCancelled == true { continuation.finish(); return }
                    guard let t = destTags[tag.id] else { continue }
                    for entry in tag.entries {
                        if let de = destEntries[entry.id], !t.entries.contains(where: { $0.id == de.id }) {
                            t.entries.append(de)
                        }
                    }
                }
                for thread in allThreads {
                    if token?.isCancelled == true { continuation.finish(); return }
                    guard let th = destThreads[thread.id] else { continue }
                    for entry in thread.entries {
                        if let de = destEntries[entry.id], !th.entries.contains(where: { $0.id == de.id }) {
                            th.entries.append(de)
                        }
                    }
                }
                try? destContext.save()

                // UserSettings (single row) – carry across basic flags only
                if let srcSettings = allSettings.first {
                    if token?.isCancelled == true { continuation.finish(); return }
                    let copy = UserSettings(id: srcSettings.id)
                    copy.hasCompletedOnboarding = srcSettings.hasCompletedOnboarding
                    copy.iCloudSyncEnabled = true
                    copy.dailyReminderHour = srcSettings.dailyReminderHour
                    copy.selectedPromptStyleId = srcSettings.selectedPromptStyleId
                    copy.allowOnDeviceOnly = srcSettings.allowOnDeviceOnly
                    copy.ttsVoiceIdentifier = srcSettings.ttsVoiceIdentifier
                    copy.ttsRate = srcSettings.ttsRate
                    copy.ttsPitch = srcSettings.ttsPitch
                    copy.weeklyInsightsEnabled = srcSettings.weeklyInsightsEnabled
                    copy.spotlightIndexingEnabled = srcSettings.spotlightIndexingEnabled
                    destContext.insert(copy)
                    try? destContext.save()
                    migratedCount += 1
                    continuation.yield(.init(total: total, migrated: migratedCount))
                }

                logger.log("sync_migrate_completed")
                continuation.finish()
            }
        }
    }

    // MARK: - Helpers

    @MainActor
    private func upsert(_ style: PromptStyle, into context: ModelContext) {
        let existing: [PromptStyle] = (try? context.fetch(FetchDescriptor<PromptStyle>())) ?? []
        if existing.contains(where: { $0.id == style.id }) { return }
        let copy = PromptStyle(
            id: style.id,
            displayName: style.displayName,
            maxSentences: style.maxSentences,
            includeActionItems: style.includeActionItems,
            toneHint: style.toneHint,
            isPremium: style.isPremium
        )
        context.insert(copy)
    }

    @MainActor
    private func upsert(_ tag: Tag, into context: ModelContext) {
        let fetch: [Tag] = (try? context.fetch(FetchDescriptor<Tag>())) ?? []
        if fetch.contains(where: { $0.id == tag.id }) { return }
        let copy = Tag(id: tag.id, name: tag.name)
        context.insert(copy)
    }

    @MainActor
    private func upsert(_ thread: MemoryThread, into context: ModelContext, includeEntries: Bool) {
        let fetch: [MemoryThread] = (try? context.fetch(FetchDescriptor<MemoryThread>())) ?? []
        if fetch.contains(where: { $0.id == thread.id }) { return }
        let copy = MemoryThread(id: thread.id, title: thread.title, createdAt: thread.createdAt)
        copy.updatedAt = thread.updatedAt
        context.insert(copy)
        if includeEntries { /* entries re-linked later */ }
    }
}
