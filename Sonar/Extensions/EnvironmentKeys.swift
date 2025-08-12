import StoreKit
import SwiftUI

private struct TranscriptionKey: EnvironmentKey { static let defaultValue: any SpeechTranscriptionService = DefaultTranscriptionService() }
private struct SummarizationKey: EnvironmentKey { static let defaultValue: any SummarizationService = DefaultSummarizationService() }
private struct MoodKey: EnvironmentKey { static let defaultValue: any MoodAnalysisService = DefaultMoodAnalysisService() }
private struct IndexingKey: EnvironmentKey { static let defaultValue: any SearchIndexingService = DefaultSearchIndexingService() }
private struct PurchasesKey: EnvironmentKey { static let defaultValue: any PurchasesService = DefaultPurchasesService() }
private struct TTSKey: EnvironmentKey { static let defaultValue: any TextToSpeechService = DefaultTextToSpeechService() }
private struct InsightsKey: EnvironmentKey { static let defaultValue: any InsightsService = DefaultInsightsService() }
private struct PromptsKey: EnvironmentKey { static let defaultValue: any PromptsService = DefaultPromptsService() }
private struct ReviewKey: EnvironmentKey { static let defaultValue: any ReviewRequestService = DefaultReviewRequestService() }
private struct BackupKey: EnvironmentKey { static let defaultValue: any BackupService = DefaultBackupService() }

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

    var purchases: any PurchasesService {
        get { self[PurchasesKey.self] }
        set { self[PurchasesKey.self] = newValue }
    }

    var tts: any TextToSpeechService {
        get { self[TTSKey.self] }
        set { self[TTSKey.self] = newValue }
    }

    var insights: any InsightsService {
        get { self[InsightsKey.self] }
        set { self[InsightsKey.self] = newValue }
    }

    var prompts: any PromptsService {
        get { self[PromptsKey.self] }
        set { self[PromptsKey.self] = newValue }
    }

    var review: any ReviewRequestService {
        get { self[ReviewKey.self] }
        set { self[ReviewKey.self] = newValue }
    }

    var backup: any BackupService {
        get { self[BackupKey.self] }
        set { self[BackupKey.self] = newValue }
    }
}
