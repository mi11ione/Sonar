import Foundation
import OSLog
import SwiftData

protocol BackupService: Sendable {
    @MainActor func exportAll(toTemporaryFilename filename: String?, using context: ModelContext) async throws -> URL
    @MainActor func `import`(from url: URL, using context: ModelContext) async throws -> ImportResult
}

struct ImportResult: Sendable {
    let entriesUpserted: Int
    let entriesUpdated: Int
    let audioFilesWritten: Int
}

final class DefaultBackupService: BackupService {
    private let logger = Logger.data

    @MainActor
    func exportAll(toTemporaryFilename filename: String? = nil, using context: ModelContext) async throws -> URL {
        logger.log("export_started")
        let exportURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(filename ?? "Sonar-Export.json")

        // Fetch all entities
        let entries: [JournalEntry] = (try? context.fetch(FetchDescriptor<JournalEntry>())) ?? []
        let tags: [Tag] = (try? context.fetch(FetchDescriptor<Tag>())) ?? []
        let threads: [MemoryThread] = (try? context.fetch(FetchDescriptor<MemoryThread>())) ?? []

        var exportPayload: [String: Any] = [:]
        exportPayload["exportInfo"] = [
            "createdAtEpochSec": Date().timeIntervalSince1970,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-",
        ]

        // Build lookups
        let tagNamesByEntry: [UUID: [String]] = {
            var dict: [UUID: [String]] = [:]
            for t in tags {
                for e in t.entries {
                    dict[e.id, default: []].append(t.name)
                }
            }
            return dict
        }()
        let threadTitlesByEntry: [UUID: [String]] = {
            var dict: [UUID: [String]] = [:]
            for th in threads {
                for e in th.entries {
                    dict[e.id, default: []].append(th.title)
                }
            }
            return dict
        }()

        // Build entries array with optional base64 audio
        var entriesArray: [[String: Any]] = []
        entriesArray.reserveCapacity(entries.count)
        for e in entries {
            var item: [String: Any] = [
                "id": e.id.uuidString,
                "createdAt": e.createdAt.timeIntervalSince1970,
                "updatedAt": e.updatedAt.timeIntervalSince1970,
                "transcript": e.transcript,
                "isPinned": e.isPinned,
                "tags": tagNamesByEntry[e.id] ?? [],
                "threads": threadTitlesByEntry[e.id] ?? [],
            ]
            if let title = e.title { item["title"] = title }
            if let notes = e.notes { item["notes"] = notes }
            if let summary = e.summary { item["summary"] = summary }
            if let s = e.moodScore { item["moodScore"] = s }
            if let l = e.moodLabel { item["moodLabel"] = l }

            if let audio = e.audio {
                let resolved = audio.resolvedFileURL
                let filename = resolved.lastPathComponent
                // Read file in chunks to avoid large memory spikes
                let base64 = try? Self.base64EncodeFile(at: resolved)
                item["audio"] = [
                    "filename": filename,
                    "durationSec": audio.durationSec,
                    "sampleRate": audio.sampleRate,
                    "base64": base64 ?? "",
                ]
            } else {
                item["audio"] = NSNull()
            }
            entriesArray.append(item)
        }
        exportPayload["entries"] = entriesArray

        // Serialize JSON (pretty for readability)
        guard JSONSerialization.isValidJSONObject(exportPayload) else {
            throw CocoaError(.featureUnsupported)
        }
        let data = try JSONSerialization.data(withJSONObject: exportPayload, options: [.prettyPrinted])
        try data.write(to: exportURL, options: [.atomic])
        logger.log("export_completed count=\(entries.count)")
        return exportURL
    }

    // MARK: - Helpers

    private static func base64EncodeFile(at url: URL) throws -> String {
        let handle = try FileHandle(forReadingFrom: url)
        defer { try? handle.close() }
        let chunkSize = 256 * 1024
        var encoded = ""
        while true {
            let data = try handle.read(upToCount: chunkSize) ?? Data()
            if data.isEmpty { break }
            encoded.append(data.base64EncodedString())
        }
        return encoded
    }

    @MainActor
    func `import`(from url: URL, using context: ModelContext) async throws -> ImportResult {
        logger.log("import_started")
        let data = try Data(contentsOf: url)
        let any = try JSONSerialization.jsonObject(with: data, options: [])
        guard let root = any as? [String: Any], let arr = root["entries"] as? [[String: Any]] else {
            throw CocoaError(.fileReadCorruptFile)
        }

        // Preload existing maps
        let existingEntries: [UUID: JournalEntry] = {
            let all: [JournalEntry] = (try? context.fetch(FetchDescriptor<JournalEntry>())) ?? []
            return Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
        }()
        var tagByName: [String: Tag] = {
            let all: [Tag] = (try? context.fetch(FetchDescriptor<Tag>())) ?? []
            return Dictionary(uniqueKeysWithValues: all.map { ($0.name.lowercased(), $0) })
        }()
        var threadByTitle: [String: MemoryThread] = {
            let all: [MemoryThread] = (try? context.fetch(FetchDescriptor<MemoryThread>())) ?? []
            return Dictionary(uniqueKeysWithValues: all.map { ($0.title.lowercased(), $0) })
        }()

        var upserted = 0
        var updated = 0
        var audioWritten = 0

        // Ensure audio directory exists
        let appSupport = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let audioDir = appSupport.appendingPathComponent("Audio", isDirectory: true)
        try FileManager.default.createDirectory(at: audioDir, withIntermediateDirectories: true)

        for item in arr {
            guard let idString = item["id"] as? String, let id = UUID(uuidString: idString) else { continue }
            let createdAt = Date(timeIntervalSince1970: (item["createdAt"] as? Double) ?? Date().timeIntervalSince1970)
            let updatedAtIncoming = Date(timeIntervalSince1970: (item["updatedAt"] as? Double) ?? createdAt.timeIntervalSince1970)

            let title = item["title"] as? String
            let notes = item["notes"] as? String
            let transcript = (item["transcript"] as? String) ?? ""
            let summary = item["summary"] as? String
            let moodScore = item["moodScore"] as? Double
            let moodLabel = item["moodLabel"] as? String
            let isPinned = (item["isPinned"] as? Bool) ?? false

            let tagNames = (item["tags"] as? [String]) ?? []
            let threadTitles = (item["threads"] as? [String]) ?? []

            let existing = existingEntries[id]
            let entry: JournalEntry
            if let ex = existing {
                // Update if incoming is newer
                if updatedAtIncoming > ex.updatedAt {
                    ex.title = title
                    ex.notes = notes
                    ex.transcript = transcript
                    ex.summary = summary
                    ex.moodScore = moodScore
                    ex.moodLabel = moodLabel
                    ex.isPinned = isPinned
                    ex.updatedAt = updatedAtIncoming
                    updated += 1
                }
                entry = ex
            } else {
                entry = JournalEntry(id: id, createdAt: createdAt, transcript: transcript)
                entry.title = title
                entry.notes = notes
                entry.summary = summary
                entry.moodScore = moodScore
                entry.moodLabel = moodLabel
                entry.isPinned = isPinned
                entry.updatedAt = updatedAtIncoming
                context.insert(entry)
                upserted += 1
            }

            // Tags
            var newTags: [Tag] = []
            newTags.reserveCapacity(tagNames.count)
            for name in tagNames {
                let key = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                guard !key.isEmpty else { continue }
                let tag = tagByName[key] ?? {
                    let t = Tag(name: name)
                    context.insert(t)
                    tagByName[key] = t
                    return t
                }()
                if !entry.tags.contains(where: { $0.id == tag.id }) { newTags.append(tag) }
            }
            entry.tags.append(contentsOf: newTags)

            // Threads
            for title in threadTitles {
                let key = title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                guard !key.isEmpty else { continue }
                let thread = threadByTitle[key] ?? {
                    let t = MemoryThread(title: title)
                    context.insert(t)
                    threadByTitle[key] = t
                    return t
                }()
                if !thread.entries.contains(where: { $0.id == entry.id }) {
                    thread.entries.append(entry)
                }
            }

            // Audio
            if let audio = item["audio"] as? [String: Any], let b64 = audio["base64"] as? String, !b64.isEmpty {
                let filename = (audio["filename"] as? String) ?? "\(id).caf"
                var outURL = audioDir.appendingPathComponent(filename)
                if let raw = Data(base64Encoded: b64) {
                    try raw.write(to: outURL, options: [.atomic])
                    var resourceValues = URLResourceValues()
                    resourceValues.isExcludedFromBackup = true
                    try? outURL.setResourceValues(resourceValues)
                    try? FileManager.default.setAttributes([.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication], ofItemAtPath: outURL.path)

                    if entry.audio == nil {
                        entry.audio = AudioAsset(fileURL: outURL, durationSec: (audio["durationSec"] as? Double) ?? 0, sampleRate: (audio["sampleRate"] as? Double) ?? 0)
                    } else if let asset = entry.audio {
                        asset.fileURL = outURL
                        asset.durationSec = (audio["durationSec"] as? Double) ?? asset.durationSec
                        asset.sampleRate = (audio["sampleRate"] as? Double) ?? asset.sampleRate
                    }
                    audioWritten += 1
                }
            }
            // Reindex changed entry in Spotlight
            await DefaultSearchIndexingService().index(entry: entry)
        }

        try context.save()
        logger.log("import_completed upserted=\(upserted) updated=\(updated) audio=\(audioWritten)")
        return ImportResult(entriesUpserted: upserted, entriesUpdated: updated, audioFilesWritten: audioWritten)
    }
}
