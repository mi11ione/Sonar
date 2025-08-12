import ActivityKit
import SwiftUI
import WidgetKit

struct RecordingActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RecordingActivityAttributes.self) { context in
            RecordingActivityLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { RecordingActivityIslandExpandedView(context: context) }
            } compactLeading: {
                RecordingActivityIslandCompactView(context: context)
            } compactTrailing: {
                EmptyView()
            } minimal: {
                RecordingActivityIslandMinimalView(context: context)
            }
        }
    }
}


