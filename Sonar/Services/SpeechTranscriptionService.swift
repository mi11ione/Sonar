import Foundation

protocol SpeechTranscriptionService: Sendable {
    func requestAuthorization() async throws
    func startStreamingTranscription(onDeviceOnly: Bool) async throws -> AsyncStream<String>
    func stop() async
    /// Starts audio capture without transcription (fallback when on-device is unavailable).
    func startAudioOnlyRecording() async throws
    /// The most recent recording file URL if available.
    func currentRecordingFileURL() -> URL?
}
