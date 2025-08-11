import Foundation

protocol SpeechTranscriptionService: Sendable {
    func requestAuthorization() async throws
    func startStreamingTranscription(onDeviceOnly: Bool) async throws -> AsyncStream<String>
    func stop() async
    /// Starts audio capture without transcription (fallback when on-device is unavailable).
    func startAudioOnlyRecording() async throws
    /// The most recent recording file URL if available.
    func currentRecordingFileURL() -> URL?
    /// A lightweight stream of normalized microphone amplitudes in [0, 1].
    /// The stream yields while recording/transcribing, and terminates when stopped.
    func amplitudeStream() -> AsyncStream<Float>
}
