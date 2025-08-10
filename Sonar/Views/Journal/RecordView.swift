import SwiftData
import SwiftUI

struct RecordView: View {
    @Environment(\.transcription) private var transcription
    @Environment(\.summarization) private var summarization
    @Environment(\.moodAnalysis) private var mood
    @Environment(\.indexing) private var indexing
    @Environment(\.modelContext) private var modelContext
    @Environment(\.purchases) private var purchases

    enum ViewState: Equatable { case idle, recording, processing, saved, error(String) }
    @State private var state: ViewState = .idle
    @State private var liveTranscript: String = ""
    @State private var startTime: Date? = nil
    @AppStorage("freeCount") private var freeCount: Int = 0
    @State private var showPaywall: Bool = false
    @State private var isPaused: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Group {
                switch state {
                case .recording:
                    if let startTime { Text(startTime, style: .timer).font(.title3.monospacedDigit()) }
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

            if state == .recording { WaveformView(transcript: liveTranscript) }

            ScrollView { Text(liveTranscript).frame(maxWidth: .infinity, alignment: .leading) }

            micControl
        }
        .padding()
        .navigationTitle("Record")
        .sensoryFeedback(.impact(weight: .light), trigger: state == .recording)
        .sensoryFeedback(.impact(weight: .light), trigger: state == .processing)
        .sensoryFeedback(.success, trigger: state == .saved)
        .task(id: state) { await handleStateChange() }
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    @ViewBuilder private var micControl: some View {
        switch state {
        case .idle:
            MicButton(title: "Start Recording") { Task { await startRecordingOrGate() } }
        case .recording:
            HStack(spacing: 12) {
                MicButton(title: isPaused ? "Resume" : "Pause", systemImageName: isPaused ? "play.fill" : "pause.fill", tint: .orange) {
                    isPaused.toggle()
                }
                MicButton(title: "Stop", systemImageName: "stop.fill", tint: .red) {
                    Task { await transcription.stop(); state = .processing }
                }
            }
        case .processing:
            MicButton(title: "Processing…", systemImageName: "hourglass", tint: .gray, isDisabled: true) {}
        case .saved:
            MicButton(title: "Start Recording") { state = .recording }
        case .error:
            MicButton(title: "Try Again", systemImageName: "arrow.clockwise") {
                state = .idle
                liveTranscript = ""
            }
        }
    }

    private func handleStateChange() async {
        switch state {
        case .recording:
            liveTranscript = ""
            do {
                try await transcription.requestAuthorization()
                let stream = try await transcription.startStreamingTranscription(onDeviceOnly: true)
                if startTime == nil { startTime = .now }
                for await chunk in stream {
                    if isPaused { continue }
                    if liveTranscript.isEmpty { liveTranscript = chunk }
                    else if chunk.hasPrefix(liveTranscript) { /* incremental */ liveTranscript = chunk }
                    else { liveTranscript += " " + chunk }
                }
            } catch {
                state = .error(error.localizedDescription)
            }
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

    private func saveEntry(from transcript: String) async {
        do {
            // Save immediately to keep UI responsive
            let entry = JournalEntry(transcript: transcript)
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
}

#Preview {
    NavigationStack { RecordView() }
}
