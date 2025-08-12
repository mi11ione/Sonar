import ActivityKit
import Foundation
import OSLog

/// Coordinates the lifecycle of the Recording Live Activity.
/// Starts and updates a single activity at a time.
///
/// Activity APIs:
/// - Start: Activity.request(attributes:content:pushType:style:) — framework-sources/ActivityKit.md lines 136-142
/// - Update: activity.update(_:) — framework-sources/ActivityKit.md lines 316-321
/// - End: activity.end(_:dismissalPolicy:) — framework-sources/ActivityKit.md lines 410-415
@MainActor
final class RecordingActivityCoordinator {
    static let shared = RecordingActivityCoordinator()

    private(set) var activity: Activity<RecordingActivityAttributes>?
    private var timerTask: Task<Void, Never>?
    private var levelStreamTask: Task<Void, Never>?
    private var startedAt: Date?
    private var elapsedSeconds: Int = 0
    private var isPaused: Bool = false
    private var lastLevelHint: Float = 0

    private init() {}

    func start(id: String = UUID().uuidString, locale: Locale = .current) {
        guard activity == nil else { return }

        let attributes = RecordingActivityAttributes(id: id, startedAt: .now, deviceLocale: locale.identifier)
        let contentState = RecordingActivityAttributes.ContentState(
            elapsedSeconds: 0,
            isPaused: false,
            levelHint: 0,
            entryId: nil
        )
        let content = ActivityContent(state: contentState, staleDate: nil, relevanceScore: 1.0)
        do {
            // Standard style; no push updates
            activity = try Activity.request(attributes: attributes, content: content, pushType: nil, style: .standard)
            startedAt = .now
            elapsedSeconds = 0
            isPaused = false
            lastLevelHint = 0
            startTimer()
        } catch {
            Logger.capture.error("Live Activity start failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    func pause() {
        isPaused = true
    }

    func resume() {
        isPaused = false
    }

    func bindLevelStream(_ stream: AsyncStream<Float>) {
        levelStreamTask?.cancel()
        levelStreamTask = Task { [weak self] in
            guard let self else { return }
            var lastEmit: Date = .distantPast
            for await level in stream {
                // Throttle to ~4 Hz
                let now = Date()
                if now.timeIntervalSince(lastEmit) >= 0.25 {
                    lastEmit = now
                    self.lastLevelHint = min(max(level, 0), 1)
                    await self.pushUpdate()
                }
            }
        }
    }

    func end(entryId: UUID?) async {
        timerTask?.cancel(); timerTask = nil
        levelStreamTask?.cancel(); levelStreamTask = nil
        guard let activity else { return }
        var state = RecordingActivityAttributes.ContentState(
            elapsedSeconds: elapsedSeconds,
            isPaused: isPaused,
            levelHint: lastLevelHint,
            entryId: entryId
        )
        // Cap to 23:59:59 visually by clamping seconds used in UI; content still uses exact value
        if state.elapsedSeconds > 86_399 { state.elapsedSeconds = 86_399 }
        let finalContent = ActivityContent(state: state, staleDate: nil, relevanceScore: 1.0)
        await activity.end(finalContent, dismissalPolicy: .default)
        self.activity = nil
        self.startedAt = nil
    }

    private func startTimer() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            guard let self else { return }
            // Align to wall clock seconds to reduce jitter
            let remainder = 1.0 - (Date().timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1.0))
            try? await Task.sleep(for: .seconds(remainder))
            while !Task.isCancelled {
                if !self.isPaused { self.elapsedSeconds += 1 }
                await self.pushUpdate()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    private func pushUpdate() async {
        guard let activity else { return }
        var state = RecordingActivityAttributes.ContentState(
            elapsedSeconds: elapsedSeconds,
            isPaused: isPaused,
            levelHint: lastLevelHint,
            entryId: nil
        )
        if state.elapsedSeconds > 86_399 { state.elapsedSeconds = 86_399 }
        let content = ActivityContent(state: state, staleDate: nil, relevanceScore: 1.0)
        await activity.update(content)
    }
}


