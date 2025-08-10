import Foundation

struct DefaultTranscriptionService: SpeechTranscriptionService, Sendable {
    func requestAuthorization() async throws { /* Permissions will be handled later */ }

    func startStreamingTranscription(onDeviceOnly _: Bool) async throws -> AsyncStream<String> {
        AsyncStream { continuation in
            // Stub: immediately finish with empty stream
            continuation.finish()
        }
    }

    func stop() async { /* no-op */ }
}
