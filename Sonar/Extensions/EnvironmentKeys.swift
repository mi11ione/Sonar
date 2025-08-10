import SwiftUI

private struct TranscriptionKey: EnvironmentKey { static let defaultValue: any SpeechTranscriptionService = DefaultTranscriptionService() }
private struct SummarizationKey: EnvironmentKey { static let defaultValue: any SummarizationService = DefaultSummarizationService() }
private struct MoodKey: EnvironmentKey { static let defaultValue: any MoodAnalysisService = DefaultMoodAnalysisService() }
private struct IndexingKey: EnvironmentKey { static let defaultValue: any SearchIndexingService = DefaultSearchIndexingService() }

extension EnvironmentValues {
    var transcription: any SpeechTranscriptionService {
        get { self[TranscriptionKey.self] }
        set { self[TranscriptionKey.self] = newValue }
    }

    var summarization: any SummarizationService {
        get { self[SummarizationKey.self] }
        set { self[SummarizationKey.self] = newValue }
    }

    var moodAnalysis: any MoodAnalysisService {
        get { self[MoodKey.self] }
        set { self[MoodKey.self] = newValue }
    }

    var indexing: any SearchIndexingService {
        get { self[IndexingKey.self] }
        set { self[IndexingKey.self] = newValue }
    }
}
