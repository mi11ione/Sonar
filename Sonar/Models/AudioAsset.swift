import Foundation
import SwiftData

@Model
final class AudioAsset {
    @Attribute(.unique) var id: UUID
    var fileURL: URL
    var durationSec: Double
    var sampleRate: Double

    init(id: UUID = .init(), fileURL: URL, durationSec: Double, sampleRate: Double) {
        self.id = id
        self.fileURL = fileURL
        self.durationSec = durationSec
        self.sampleRate = sampleRate
    }
}

extension AudioAsset {
    /// Returns a usable URL for the audio file. Falls back to resolving the file
    /// under the current Application Support/Audio directory by filename if the
    /// stored absolute path no longer exists (e.g., after reinstall or container move).
    var resolvedFileURL: URL {
        // Use stored URL if it still exists on disk
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return fileURL
        }
        // Reconstruct a best-effort path using the known audio folder and filename
        let filename = fileURL.lastPathComponent
        if let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let audioDir = appSupport.appendingPathComponent("Audio", isDirectory: true)
            let candidate = audioDir.appendingPathComponent(filename)
            return candidate
        }
        return fileURL
    }
}
