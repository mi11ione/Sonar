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
                    Label("Saved", systemImage: "checkmark.circle")
                        .foregroundStyle(.green)
                        .font(.headline)
                default:
                    EmptyView()
                }
            }

            if state == .recording || state == .recordingAudioOnly { WaveformView(transcript: liveTranscript) }
            if state == .recordingAudioOnly {
                Text("On-device transcription unavailable. Recording audio only.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if state == .review {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Review transcript").font(.headline)
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
        .navigationTitle("Record")
        .sensoryFeedback(.impact(weight: .light), trigger: state == .recording)
        .sensoryFeedback(.impact(weight: .light), trigger: state == .processing)
        .sensoryFeedback(.success, trigger: state == .saved)
        .sensoryFeedback(.impact(weight: .light), trigger: isPaused)
        .sensoryFeedback(.impact(weight: .light), trigger: didDiscardToggle)
        .task(id: state) { await handleStateChange() }
        .task(id: lastResumeAt) { await enforceLongSessionGuardIfNeeded() }
        .sheet(isPresented: $showPaywall) { PaywallView() }
        .onChange(of: showPaywall) { if showPaywall { review.recordPaywallShown(now: .now) } }
        .task {
            if deepLinkStart {
                deepLinkStart = false
                await startRecordingOrGate()
            }
        }
        .privacySensitive()
        .task { await checkForOrphanAudioToRecover() }
        .alert("Recovered recording found", isPresented: $showRecoveryAlert) {
            Button("Discard", role: .destructive) { discardRecovered() }
            Button("Save") { Task { await saveRecovered() } }
        } message: {
            Text("A previous recording didn’t finish saving. You can save it as a new entry or discard it.")
        }
    }

    @ViewBuilder private var micControl: some View {
        switch state {
        case .idle:
            MicButton(title: "Start Recording") { Task { await startRecordingOrGate() } }
        case .recording:
            HStack(spacing: 12) {
                MicButton(title: isPaused ? "Resume" : "Pause", systemImageName: isPaused ? "play.fill" : "pause.fill", tint: .orange) {
                    if !isPaused {
                        committedTranscript = liveTranscript
                        if let last = lastResumeAt { elapsedBeforePause += Date().timeIntervalSince(last) }
                        isPaused = true
                        Task { await transcription.stop() }
                    } else {
                        isPaused = false
                        lastResumeAt = Date()
                        Task { await streamTranscription() }
                    }
                }
                MicButton(title: "Stop", systemImageName: "stop.fill", tint: .red) {
                    if let last = lastResumeAt { elapsedBeforePause += Date().timeIntervalSince(last) }
                    Task {
                        await transcription.stop()
                        UserDefaults.standard.set(false, forKey: "recording.inProgress")
                        state = .review
                    }
                }
            }
        case .recordingAudioOnly:
            HStack(spacing: 12) {
                MicButton(title: isPaused ? "Resume" : "Pause", systemImageName: isPaused ? "play.fill" : "pause.fill", tint: .orange) {
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
                MicButton(title: "Stop", systemImageName: "stop.fill", tint: .red) {
                    if let last = lastResumeAt { elapsedBeforePause += Date().timeIntervalSince(last) }
                    Task {
                        await transcription.stop()
                        UserDefaults.standard.set(false, forKey: "recording.inProgress")
                        state = .review
                    }
                }
            }
        case .review:
            HStack(spacing: 12) {
                MicButton(title: "Save", systemImageName: "checkmark", tint: .green, font: .title3.bold()) {
                    liveTranscript = reviewText
                    state = .processing
                }
                MicButton(title: "Discard", systemImageName: "xmark", tint: .gray, font: .title3.bold()) {
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
            MicButton(title: "Processing…", systemImageName: "hourglass", tint: .gray, isDisabled: true) {}
        case .saved:
            MicButton(title: "Start Recording") { state = .recording }
        case .error:
            VStack(spacing: 8) {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                MicButton(title: "Try Again", systemImageName: "arrow.clockwise") {
                    state = .idle
                    liveTranscript = ""
                }
                Button("Open Settings") {
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
                let maxSentences = preferred?.maxSentences ?? 3
                let tone = preferred?.toneHint
                let summary = await summarization.summarize(text: transcript, maxSentences: maxSentences, toneHint: tone)
                let result = await mood.analyze(text: transcript)
                await MainActor.run {
                    entry.summary = summary
                    entry.moodScore = result.score
                    entry.moodLabel = result.label
                    try? modelContext.save()
                }
                await indexing.index(entry: entry)
            }
            await gateUsagePostSave()
            await requestReviewIfAppropriate()
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func startRecordingOrGate() async {
        // Gate if free tier exhausted and not subscribed
        let subscribed = await purchases.isSubscriber()
        if !subscribed, freeCount >= 3 {
            showPaywall = true
            return
        }
        isPaused = false
        state = .recording
    }

    private func gateUsagePostSave() async {
        let subscribed = await purchases.isSubscriber()
        if !subscribed {
            freeCount += 1
            if freeCount >= 3 { showPaywall = true }
        }
    }

    private func requestReviewIfAppropriate() async {
        review.recordAppActive(now: .now)
        if review.shouldRequestReview(after: .entrySaved, now: .now) {
            await MainActor.run { requestReview() }
        }
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
        recoveryURL = url
        showRecoveryAlert = true
    }

    private func discardRecovered() {
        guard let url = recoveryURL else { return }
        try? FileManager.default.removeItem(at: url)
        recoveryURL = nil
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
                entry.title = "Recovered recording"
                entry.notes = "Recovered after an interruption."
            }
            modelContext.insert(entry)
            try modelContext.save()
            await indexing.index(entry: entry)
        } catch {
            // ignore
        }
        recoveryURL = nil
    }
}

#Preview {
    NavigationStack { RecordView() }
}
