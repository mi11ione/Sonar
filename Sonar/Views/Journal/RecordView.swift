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

    var body: some View {
        VStack(spacing: 16) {
            switch state {
            case .idle:
                MicButton(title: "Start Recording") { state = .recording }
            case .recording:
                VStack(spacing: 12) {
                    ScrollView { Text(liveTranscript).frame(maxWidth: .infinity, alignment: .leading) }
                    Button(role: .destructive) { Task { await transcription.stop(); state = .processing } } label: {
                        Label("Stop", systemImage: "stop.fill")
                    }
                    .buttonStyle(.borderedProminent)
                }
            case .processing:
                ProgressView("Processing…")
            case .saved:
                ContentUnavailableView("Saved", systemImage: "checkmark.circle")
            case let .error(message):
                ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(message))
            }
        }
        .padding()
        .navigationTitle("Record")
        .task(id: state) { await handleStateChange() }
    }

    private func handleStateChange() async {
        switch state {
        case .recording:
            liveTranscript = ""
            do {
                let stream = try await transcription.startStreamingTranscription(onDeviceOnly: true)
                for await chunk in stream {
                    liveTranscript = chunk
                }
            } catch {
                state = .error(error.localizedDescription)
            }
        case .processing:
            await saveEntry(from: liveTranscript)
        default:
            break
        }
    }

    private func saveEntry(from transcript: String) async {
        do {
            let summary = await summarization.summarize(text: transcript, maxSentences: 3, toneHint: nil)
            let result = await mood.analyze(text: transcript)

            let entry = JournalEntry(transcript: transcript)
            entry.summary = summary
            entry.moodScore = result.score
            entry.moodLabel = result.label
            modelContext.insert(entry)
            try modelContext.save()

            await indexing.index(entry: entry)
            state = .saved
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack { RecordView() }
}
