import SwiftData
import SwiftUI

struct RecordView: View {
    @Environment(\.transcription) private var transcription
    @Environment(\.summarization) private var summarization
    @Environment(\.moodAnalysis) private var mood
    @Environment(\.indexing) private var indexing
    @Environment(\.modelContext) private var modelContext

    enum ViewState: Equatable { case idle, recording, processing, saved, error(String) }
    @State private var state: ViewState = .idle
    @State private var liveTranscript: String = ""
    @State private var startTime: Date? = nil

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

            ScrollView { Text(liveTranscript).frame(maxWidth: .infinity, alignment: .leading) }

            micControl
        }
        .padding()
        .navigationTitle("Record")
        .sensoryFeedback(.impact(weight: .light), trigger: state == .recording)
        .sensoryFeedback(.impact(weight: .light), trigger: state == .processing)
        .sensoryFeedback(.success, trigger: state == .saved)
        .task(id: state) { await handleStateChange() }
    }

    @ViewBuilder private var micControl: some View {
        switch state {
        case .idle:
            MicButton(title: "Start Recording") { state = .recording }
        case .recording:
            MicButton(title: "Stop", systemImageName: "stop.fill", tint: .red) {
                Task { await transcription.stop(); state = .processing }
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
                    liveTranscript = chunk
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

            // Background processing for summary, mood, and indexing
            Task(priority: .utility) {
                let summary = await summarization.summarize(text: transcript, maxSentences: 3, toneHint: nil)
                let result = await mood.analyze(text: transcript)
                await MainActor.run {
                    entry.summary = summary
                    entry.moodScore = result.score
                    entry.moodLabel = result.label
                    try? modelContext.save()
                }
                await indexing.index(entry: entry)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack { RecordView() }
}
