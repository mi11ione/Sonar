import ActivityKit
import SwiftUI
import WidgetKit

// NOTE: This file provides the views for the Live Activity. It is placed in-app
// per STOP gate; to fully enable, move this into a Widget extension target and
// wrap in ActivityConfiguration(for: RecordingActivityAttributes.self, ...).

struct RecordingActivityLockScreenView: View {
    let context: ActivityViewContext<RecordingActivityAttributes>

    private var timerText: String {
        let seconds = min(max(context.state.elapsedSeconds, 0), 86399)
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = seconds >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: TimeInterval(seconds)) ?? "0:00"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("recording_ellipsis")
                .font(.headline)
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "mic.fill")
                    .foregroundStyle(context.state.isPaused ? Color.secondary : .red)
                Text(timerText)
                    .font(.title3.monospacedDigit())
            }
            ProgressView(value: Double(context.state.levelHint))
                .progressViewStyle(.linear)
                .tint(.accentColor)
            HStack {
                Button(role: .destructive) { Task { try? await StopRecordingIntent().perform() } } label: {
                    Label("stop", systemImage: "stop.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                if context.state.isPaused {
                    Button { Task { try? await TogglePauseRecordingIntent().perform() } } label: {
                        Label("resume", systemImage: "play.fill")
                    }
                } else {
                    Button { Task { try? await TogglePauseRecordingIntent().perform() } } label: {
                        Label("pause", systemImage: "pause.fill")
                    }
                }
            }
        }
        .padding(12)
    }
}

struct RecordingActivityIslandExpandedView: View {
    let context: ActivityViewContext<RecordingActivityAttributes>
    var body: some View {
        RecordingActivityLockScreenView(context: context)
    }
}

struct RecordingActivityIslandMinimalView: View {
    let context: ActivityViewContext<RecordingActivityAttributes>
    var body: some View {
        Image(systemName: "mic.fill")
    }
}

struct RecordingActivityIslandCompactView: View {
    let context: ActivityViewContext<RecordingActivityAttributes>
    private var timerText: String {
        let seconds = min(max(context.state.elapsedSeconds, 0), 86399)
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(.red).frame(width: 8, height: 8)
            Text(timerText).font(.caption.monospacedDigit())
        }
    }
}
