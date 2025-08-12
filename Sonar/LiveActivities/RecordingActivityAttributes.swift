import ActivityKit
import Foundation

/// Live Activity attributes for an in-progress Sonar recording.
///
/// References:
/// - ActivityAttributes protocol: see framework-sources/ActivityKit.md lines 654-694
/// - ActivityContent and request(_:content:pushType:style:): see framework-sources/ActivityKit.md lines 936-969 and 136-142
struct RecordingActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        /// Elapsed recording time in seconds (capped visually to 23:59:59 in UI logic).
        var elapsedSeconds: Int
        /// Whether recording is currently paused.
        var isPaused: Bool
        /// A debounced audio level hint in [0, 1].
        var levelHint: Float
        /// Assigned after save; optional.
        var entryId: UUID?
    }

    /// A unique identifier for this activity instance.
    var id: String
    /// Start time of the recording.
    var startedAt: Date
    /// Device locale identifier (e.g., "en_US").
    var deviceLocale: String
}
