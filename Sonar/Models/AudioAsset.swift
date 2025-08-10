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
