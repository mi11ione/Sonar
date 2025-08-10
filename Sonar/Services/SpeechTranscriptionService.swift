import Foundation

protocol SpeechTranscriptionService: Sendable {
    func requestAuthorization() async throws
    func startStreamingTranscription(onDeviceOnly: Bool) async throws -> AsyncStream<String>
    func stop() async
}
