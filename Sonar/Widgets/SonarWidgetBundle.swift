import SwiftUI
import WidgetKit

@main
struct SonarWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuickRecordWidget()
        DailyPromptWidget()
        RecentSummaryWidget()
        RecordingActivityWidget()
    }
}
