import ActivityKit
import AVFoundation
import StoreKit
import SwiftData
import SwiftUI

struct RecordView: View {
    @Environment(\.transcription) private var transcription
    @Environment(\.summarization) private var summarization
    @Environment(\.moodAnalysis) private var mood
    @Environment(\.indexing) private var indexing
    @Environment(\.modelContext) private var modelContext
    @Environment(\.purchases) private var purchases
    @Environment(\.review) private var review
    @Query private var settingsRows: [UserSettings]

    enum ViewState: Equatable { case idle, recording, recordingAudioOnly, review, processing, saved, error(String) }
    @State private var state: ViewState = .idle
    @State private var liveTranscript: String = ""
    @State private var committedTranscript: String = ""
    @State private var startTime: Date? = nil
    @State private var lastResumeAt: Date? = nil
    @State private var elapsedBeforePause: TimeInterval = 0
    @State private var reviewText: String = ""
    @AppStorage("freeCount") private var freeCount: Int = 0
    @AppStorage("deeplink.startRecording") private var deepLinkStart: Bool = false
    @AppStorage("deeplink.stopNow") private var deepLinkStop: Bool = false
    @AppStorage("deeplink.togglePause") private var deepLinkTogglePause: Bool = false
    @AppStorage("firstRunEducationShown") private var firstRunEducationShown: Bool = false
    @State private var showPaywall: Bool = false
    @State private var isPaused: Bool = false
    @State private var didDiscardToggle: Bool = false
    @State private var longSessionWarningShown: Bool = false
    private let maxRecordingDuration: TimeInterval = 60 * 20 // 20 minutes guardrail
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        VStack(spacing: 16) {
            Group {
                switch state {
                case .recording:
                    TimelineView(.periodic(from: .now, by: 1)) { context in
                        let runningElapsed = lastResumeAt.map { context.date.timeIntervalSince($0) } ?? 0
                        let total = isPaused ? elapsedBeforePause : elapsedBeforePause + runningElapsed
                        Text(formatElapsed(total)).font(.title3.monospacedDigit())
                    }
                case .processing:
                    ProgressView().progressViewStyle(.circular)
                case .saved:
                    Label("saved", systemImage: "checkmark.circle")
                        .foregroundStyle(.green)
                        .font(.headline)
                default:
                    EmptyView()
                }
            }

            if state == .recording || state == .recordingAudioOnly { WaveformView(transcript: liveTranscript) }
            if state == .recordingAudioOnly {
                Text("audio_only_fallback")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if state == .review {
                VStack(alignment: .leading, spacing: 8) {
                    Text("review_transcript").font(.headline)
                    TextEditor(text: $reviewText)
                        .frame(minHeight: 160)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.quaternary))
                }
            } else {
                ScrollView { Text(liveTranscript).frame(maxWidth: .infinity, alignment: .leading) }
            }

            micControl
        }
        .padding()
        .navigationTitle("nav_record")
        .sensoryFeedback(.impact(weight: .light), trigger: state == .recording)
        .sensoryFeedback(.impact(weight: .light), trigger: state == .processing)
        .sensoryFeedback(.success, trigger: state == .saved)
        .sensoryFeedback(.impact(weight: .light), trigger: isPaused)
        .sensoryFeedback(.impact(weight: .light), trigger: didDiscardToggle)
        .task(id: state) { await handleStateChange() }
        .task(id: lastResumeAt) { await enforceLongSessionGuardIfNeeded() }
        .sheet(isPresented: $showPaywall) { PaywallView(source: "gate") }
        .sheet(isPresented: $showFirstRunTeach) { FirstRunTeachSheet() }
        .onChange(of: showPaywall) { if showPaywall { review.recordPaywallShown(now: .now) } }
        .task {
            if deepLinkStart {
                deepLinkStart = false
                await startRecording() // do not gate on start; gating happens on save
            }
            if deepLinkStop {
                deepLinkStop = false
                if state == .recording || state == .recordingAudioOnly { await stopFromExternalTrigger() }
            }
            if deepLinkTogglePause {
                deepLinkTogglePause = false
                if state == .recording { togglePause() }
            }
        }
        .task { await checkForOrphanAudioToRecover() }
        .onDisappear { restoreBackgroundTaskIfAny() }
        .alert("recovered_recording_found", isPresented: $showRecoveryAlert) {
            Button("discard", role: .destructive) { discardRecovered() }
            Button("save") { Task { await saveRecovered() } }
        } message: {
            Text("recovered_recording_message")
        }
    }

    @ViewBuilder private var micControl: some View {
        switch state {
        case .idle:
            MicButton(title: "start_recording") { Task { await startRecording() } }
        case .recording:
            HStack(spacing: 12) {
                MicButton(title: isPaused ? "resume" : "pause", systemImageName: isPaused ? "play.fill" : "pause.fill", tint: .orange) { togglePause() }
                MicButton(title: "stop", systemImageName: "stop.fill", tint: .red) {
                    if let last = lastResumeAt { elapsedBeforePause += Date().timeIntervalSince(last) }
                    Task {
                        await transcription.stop()
                        UserDefaults.standard.set(false, forKey: "recording.inProgress")
                        restoreBackgroundTaskIfAny()
                        state = .review
                    }
                }
            }
        case .recordingAudioOnly:
            HStack(spacing: 12) {
                MicButton(title: isPaused ? "resume" : "pause", systemImageName: isPaused ? "play.fill" : "pause.fill", tint: .orange) {
                    if !isPaused {
                        if let last = lastResumeAt { elapsedBeforePause += Date().timeIntervalSince(last) }
                        isPaused = true
                        Task { await transcription.stop() }
                    } else {
                        isPaused = false
                        lastResumeAt = Date()
                        Task { try? await transcription.startAudioOnlyRecording() }
                    }
                }
                MicButton(title: "stop", systemImageName: "stop.fill", tint: .red) {
                    if let last = lastResumeAt { elapsedBeforePause += Date().timeIntervalSince(last) }
                    Task {
                        await transcription.stop()
                        UserDefaults.standard.set(false, forKey: "recording.inProgress")
                        restoreBackgroundTaskIfAny()
                        state = .review
                    }
                }
            }
        case .review:
            HStack(spacing: 12) {
                MicButton(title: "save", systemImageName: "checkmark", tint: .green, font: .title3.bold()) {
                    Task {
                        if await guardCanSaveOrPresentPaywall() {
                            liveTranscript = reviewText
                            state = .processing
                        }
                    }
                }
                MicButton(title: "discard", systemImageName: "xmark", tint: .gray, font: .title3.bold()) {
                    // Remove any temporary recording file created during this session
                    deleteCurrentRecordingFileIfAny()
                    didDiscardToggle.toggle()
                    state = .idle
                    liveTranscript = ""
                    startTime = nil
                    isPaused = false
                    lastResumeAt = nil
                    elapsedBeforePause = 0
                }
            }
        case .processing:
            MicButton(title: "processing_ellipsis", systemImageName: "hourglass", tint: .gray, isDisabled: true) {}
        case .saved:
            MicButton(title: "start_recording") { Task { await startRecording() } }
        case .error:
            VStack(spacing: 8) {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                MicButton(title: "try_again", systemImageName: "arrow.clockwise") {
                    state = .idle
                    liveTranscript = ""
                }
                Button("open_settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var errorMessage: String {
        switch state {
        case let .error(message): message
        default: ""
        }
    }

    private func handleStateChange() async {
        switch state {
        case .recording:
            liveTranscript = ""
            committedTranscript = ""
            do {
                try await transcription.requestAuthorization()
                UserDefaults.standard.set(true, forKey: "recording.inProgress")
                if startTime == nil { startTime = .now }
                lastResumeAt = Date()
                elapsedBeforePause = 0
                beginBackgroundAudioAllowance()
                RecordingActivityCoordinator.shared.start()
                RecordingActivityCoordinator.shared.bindLevelStream(transcription.amplitudeStream())
                await streamTranscription()
            } catch {
                state = .error(error.localizedDescription)
            }
        case .recordingAudioOnly:
            do {
                try await transcription.requestAuthorization()
                UserDefaults.standard.set(true, forKey: "recording.inProgress")
                if startTime == nil { startTime = .now }
                lastResumeAt = Date()
                elapsedBeforePause = 0
                beginBackgroundAudioAllowance()
                try await transcription.startAudioOnlyRecording()
            } catch {
                state = .error(error.localizedDescription)
            }
        case .review:
            reviewText = liveTranscript
        case .processing:
            await saveEntry(from: liveTranscript)
        case .saved:
            // Auto-reset to idle shortly after showing saved state
            try? await Task.sleep(for: .seconds(1.2))
            if state == .saved { state = .idle; liveTranscript = "" }
        default:
            break
        }
    }

    private func enforceLongSessionGuardIfNeeded() async {
        guard state == .recording || state == .recordingAudioOnly else { return }
        guard let start = startTime else { return }
        let elapsed = (lastResumeAt.map { Date().timeIntervalSince($0) } ?? 0) + elapsedBeforePause + Date().timeIntervalSince(start) - (start == lastResumeAt ? 0 : 0)
        if elapsed > maxRecordingDuration, !longSessionWarningShown {
            longSessionWarningShown = true
            await MainActor.run {
                state = .review
            }
        }
    }

    private func streamTranscription() async {
        do {
            let onDeviceOnly = settingsRows.first?.allowOnDeviceOnly ?? true
            let stream = try await transcription.startStreamingTranscription(onDeviceOnly: onDeviceOnly)
            for await chunk in stream {
                if isPaused { break }
                // Merge partial with committed prefix to avoid losing prior text across pauses
                if chunk.hasPrefix(committedTranscript) {
                    let suffix = String(chunk.dropFirst(committedTranscript.count)).trimmingCharacters(in: .whitespacesAndNewlines)
                    liveTranscript = suffix.isEmpty ? committedTranscript : committedTranscript + (committedTranscript.isEmpty ? "" : " ") + suffix
                } else {
                    // If recognizer restarts and drops context, keep both committed and new chunk
                    liveTranscript = committedTranscript.isEmpty ? chunk : committedTranscript + " " + chunk
                }
            }
        } catch {
            if let captureError = error as? CaptureError, captureError == .onDeviceUnavailable {
                // Fallback to network-backed recognition if on-device isn't available
                do {
                    let stream = try await transcription.startStreamingTranscription(onDeviceOnly: false)
                    for await chunk in stream {
                        if isPaused { break }
                        if chunk.hasPrefix(committedTranscript) {
                            let suffix = String(chunk.dropFirst(committedTranscript.count)).trimmingCharacters(in: .whitespacesAndNewlines)
                            liveTranscript = suffix.isEmpty ? committedTranscript : committedTranscript + (committedTranscript.isEmpty ? "" : " ") + suffix
                        } else {
                            liveTranscript = committedTranscript.isEmpty ? chunk : committedTranscript + " " + chunk
                        }
                    }
                } catch {
                    // As a last resort, record audio only
                    state = .recordingAudioOnly
                }
            } else {
                state = .error(error.localizedDescription)
            }
        }
    }

    private func formatElapsed(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = seconds >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: max(0, seconds)) ?? "0:00"
    }

    private func saveEntry(from transcript: String) async {
        do {
            // Save immediately to keep UI responsive
            let entry = JournalEntry(transcript: transcript)
            // Attach audio asset if an audio-only recording exists
            if let url = (transcription as? DefaultTranscriptionService)?.currentRecordingFileURL() {
                if let file = try? AVAudioFile(forReading: url) {
                    let rate = file.fileFormat.sampleRate
                    let duration = rate > 0 ? Double(file.length) / rate : elapsedBeforePause
                    let asset = AudioAsset(fileURL: url, durationSec: duration, sampleRate: rate)
                    entry.audio = asset
                }
            }
            modelContext.insert(entry)
            try modelContext.save()
            state = .saved
            startTime = nil
            isPaused = false

            // Background processing for summary, mood, and indexing with style preference
            Task(priority: .utility) {
                // Load preferred prompt style if available from UserSettings
                let settings: UserSettings? = try? modelContext.fetch(FetchDescriptor<UserSettings>()).first
                let styleId = settings?.selectedPromptStyleId
                let allStyles: [PromptStyle] = (try? modelContext.fetch(FetchDescriptor<PromptStyle>())) ?? []
                let preferred = allStyles.first { $0.id == styleId } ?? allStyles.first
                // Enforce plan-based gating on styles and length
                let plan = await purchases.currentPlan()
                let maxSentences: Int
                let tone: String?
                switch plan {
                case .free:
                    maxSentences = 3
                    tone = nil
                case .pro:
                    maxSentences = min((preferred?.maxSentences ?? 4), 5)
                    tone = preferred?.toneHint
                case .premium, .lifetime:
                    maxSentences = min(max((preferred?.maxSentences ?? 5), 5), 7)
                    tone = preferred?.toneHint
                }
                let summary = await summarization.summarize(text: transcript, maxSentences: maxSentences, toneHint: tone)
                let result = await mood.analyze(text: transcript)
                await MainActor.run {
                    entry.summary = summary
                    entry.moodScore = result.score
                    entry.moodLabel = result.label
                    try? modelContext.save()
                }
                await indexing.index(entry: entry)
                await WidgetBridge.shared.updateRecentSummary(entry: entry)
            }
            await RecordingActivityCoordinator.shared.end(entryId: entry.id)
            await WidgetReloader.shared.reloadAllIfNeeded()
            await gateUsagePostSave()
            await requestReviewIfAppropriate()
            if !firstRunEducationShown {
                firstRunEducationShown = true
                await MainActor.run { showFirstRunTeach = true }
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    /// Deletes the temporary audio file created by the current capture session, if any.
    private func deleteCurrentRecordingFileIfAny() {
        if let url = (transcription as? DefaultTranscriptionService)?.currentRecordingFileURL() {
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }

    private func togglePause() {
        if !isPaused {
            committedTranscript = liveTranscript
            if let last = lastResumeAt { elapsedBeforePause += Date().timeIntervalSince(last) }
            isPaused = true
            RecordingActivityCoordinator.shared.pause()
            Task { await transcription.stop() }
        } else {
            isPaused = false
            lastResumeAt = Date()
            RecordingActivityCoordinator.shared.resume()
            Task { await streamTranscription() }
        }
    }

    private func stopFromExternalTrigger() async {
        if let last = lastResumeAt { elapsedBeforePause += Date().timeIntervalSince(last) }
        await transcription.stop()
        UserDefaults.standard.set(false, forKey: "recording.inProgress")
        restoreBackgroundTaskIfAny()
        state = .review
    }

    private func startRecording() async {
        isPaused = false
        state = .recording
    }

    private func gateUsagePostSave() async {
        // Update counters post-save and trigger paywall if limits crossed
        let plan = await purchases.currentPlan()
        switch plan {
        case .free:
            freeCount += 1
            if freeCount >= 3 { showPaywall = true }
        case .pro:
            incrementDailySaveCounter()
            if dailySaveCount().count >= 5 { showPaywall = true }
        case .premium, .lifetime:
            break
        }
    }

    private func guardCanSaveOrPresentPaywall() async -> Bool {
        let plan = await purchases.currentPlan()
        switch plan {
        case .free:
            if freeCount >= 3 { showPaywall = true; return false }
            return true
        case .pro:
            let today = dailySaveCount()
            if today.count >= 5 { showPaywall = true; return false }
            return true
        case .premium, .lifetime:
            return true
        }
    }

    private func dailySaveCount() -> (token: String, count: Int) {
        let day = dayIdentifier(for: Date())
        let token = UserDefaults.standard.string(forKey: "saveCount.day")
        let count = UserDefaults.standard.integer(forKey: "saveCount.value")
        if token == day { return (day, count) }
        return (day, 0)
    }

    private func incrementDailySaveCounter() {
        let day = dayIdentifier(for: Date())
        let current = dailySaveCount()
        if current.token != day {
            UserDefaults.standard.set(day, forKey: "saveCount.day")
            UserDefaults.standard.set(1, forKey: "saveCount.value")
        } else {
            UserDefaults.standard.set(day, forKey: "saveCount.day")
            UserDefaults.standard.set(current.count + 1, forKey: "saveCount.value")
        }
    }

    private func dayIdentifier(for date: Date) -> String {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", comps.year ?? 0, comps.month ?? 0, comps.day ?? 0)
    }

    // MARK: - Review request cadence wrapper

    private func requestReviewIfAppropriate() async {
        review.record(event: .entrySaved, now: .now)
        if review.shouldRequestReview(after: .entrySaved, now: .now) {
            await MainActor.run { requestReview() }
        }
    }

    // MARK: - Long-running capture helpers

    private func beginBackgroundAudioAllowance() {
        // With UIBackgroundModes(audio) enabled in Info.plist and an active AVAudioSession
        // configured by DefaultTranscriptionService, recording continues when the screen locks.
        // No additional imperative work needed in the view.
    }

    private func restoreBackgroundTaskIfAny() {
        // No-op: we are not manually managing background tasks here.
    }

    // MARK: - First run education

    @State private var showFirstRunTeach: Bool = false

    private struct FirstRunTeachSheet: View {
        var body: some View {
            NavigationStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("education_next_title").font(.title.bold())
                    VStack(alignment: .leading, spacing: 8) {
                        Text("education_summary_title")
                            .font(.headline)
                        Text("education_summary_copy")
                            .foregroundStyle(.secondary)
                        Text("education_summary_bullets")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("education_mood_title").font(.headline)
                        HStack(spacing: 8) {
                            MoodBadge(label: String(localized: "positive"), score: 0.6)
                            Text("education_mood_badge_copy")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding()
                .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
            }
        }

        @Environment(\.dismiss) private var dismiss
    }

    // MARK: - Recovery

    @State private var recoveryURL: URL? = nil
    @State private var showRecoveryAlert: Bool = false

    private func checkForOrphanAudioToRecover() async {
        guard state == .idle else { return }
        // Clear stale flag if present
        if UserDefaults.standard.bool(forKey: "recording.inProgress") == true {
            UserDefaults.standard.set(false, forKey: "recording.inProgress")
        }
        let audioDir = (try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false))?.appendingPathComponent("Audio", isDirectory: true)
        guard let audioDir, let files = try? FileManager.default.contentsOfDirectory(at: audioDir, includingPropertiesForKeys: [.contentModificationDateKey], options: [.skipsHiddenFiles]) else { return }
        // Build set of known asset filenames
        let assets: [AudioAsset] = (try? modelContext.fetch(FetchDescriptor<AudioAsset>())) ?? []
        let known: Set<String> = Set(assets.map(\.fileURL.lastPathComponent))
        let orphans = files.filter { $0.pathExtension.lowercased() == "caf" && !known.contains($0.lastPathComponent) }
        guard let url = orphans.sorted(by: { lhs, rhs in
            let l = (try? lhs.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            let r = (try? rhs.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            return l > r
        }).first else { return }
        // Show once per file; remember last prompted filename
        let lastPrompted = UserDefaults.standard.string(forKey: "recovery.lastPromptedFilename")
        if lastPrompted != url.lastPathComponent {
            UserDefaults.standard.set(url.lastPathComponent, forKey: "recovery.lastPromptedFilename")
            recoveryURL = url
            showRecoveryAlert = true
        }
    }

    private func discardRecovered() {
        guard let url = recoveryURL else { return }
        try? FileManager.default.removeItem(at: url)
        recoveryURL = nil
        UserDefaults.standard.removeObject(forKey: "recovery.lastPromptedFilename")
    }

    private func saveRecovered() async {
        guard let url = recoveryURL else { return }
        do {
            let entry = JournalEntry(transcript: "")
            if let file = try? AVAudioFile(forReading: url) {
                let rate = file.fileFormat.sampleRate
                let duration = rate > 0 ? Double(file.length) / rate : 0
                let asset = AudioAsset(fileURL: url, durationSec: duration, sampleRate: rate)
                entry.audio = asset
                entry.title = String(localized: "recovered_recording_title")
                entry.notes = String(localized: "recovered_recording_notes")
            }
            modelContext.insert(entry)
            try modelContext.save()
            await indexing.index(entry: entry)
        } catch {
            // ignore
        }
        recoveryURL = nil
        UserDefaults.standard.removeObject(forKey: "recovery.lastPromptedFilename")
    }
}

#Preview {
    NavigationStack { RecordView() }
}
