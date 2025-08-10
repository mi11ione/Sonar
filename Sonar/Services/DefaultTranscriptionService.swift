import AVFAudio
import AVFoundation
import Foundation
import OSLog
import Speech

@MainActor
final class DefaultTranscriptionService: SpeechTranscriptionService {
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var streamContinuation: AsyncStream<String>.Continuation?
    private var isUserStopping = false
    private var didCleanup = false

    func requestAuthorization() async throws {
        // Speech authorization
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            SFSpeechRecognizer.requestAuthorization { status in
                switch status {
                case .authorized:
                    continuation.resume()
                case .denied:
                    continuation.resume(throwing: CaptureError.speechDenied)
                case .restricted, .notDetermined:
                    continuation.resume(throwing: CaptureError.speechDenied)
                @unknown default:
                    continuation.resume(throwing: CaptureError.speechDenied)
                }
            }
        }

        // Microphone authorization
        let _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
            AVAudioApplication.requestRecordPermission { granted in
                if granted { continuation.resume(returning: true) }
                else { continuation.resume(throwing: CaptureError.micDenied) }
            }
        }
    }

    func startStreamingTranscription(onDeviceOnly: Bool) async throws -> AsyncStream<String> {
        let recognizer = SFSpeechRecognizer(locale: .current)
        guard let recognizer else { throw CaptureError.onDeviceUnavailable }
        if onDeviceOnly, !recognizer.supportsOnDeviceRecognition {
            throw CaptureError.onDeviceUnavailable
        }

        if audioEngine.isRunning {
            await stop()
        }

        didCleanup = false
        isUserStopping = false

        try configureAudioSession()

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.requiresOnDeviceRecognition = onDeviceOnly
        request.shouldReportPartialResults = true
        recognitionRequest = request

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        Logger.capture.log("Audio engine started, onDeviceOnly=\(onDeviceOnly)")

        let stream = AsyncStream<String> { continuation in
            self.streamContinuation = continuation
            self.recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
                if let result {
                    continuation.yield(result.bestTranscription.formattedString)
                    if result.isFinal {
                        continuation.finish()
                        self?.cleanupRecognition()
                    }
                }
                if let error {
                    // Ignore expected errors when user stops/cancels
                    if self?.isUserStopping != true {
                        Logger.capture.error("Recognition error: \(error.localizedDescription, privacy: .public)")
                    }
                    continuation.finish()
                    self?.cleanupRecognition()
                }
            }
            // No-op on termination to avoid double stop/cleanup
            continuation.onTermination = { @Sendable _ in }
        }
        return stream
    }

    func stop() async {
        isUserStopping = true
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        streamContinuation?.finish()
        cleanupRecognition()
    }

    private func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetoothHFP])
        try session.setActive(true, options: .notifyOthersOnDeactivation)
    }

    private func cleanupRecognition() {
        if didCleanup { return }
        didCleanup = true
        recognitionTask = nil
        recognitionRequest = nil
        streamContinuation = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        Logger.capture.log("Audio engine stopped")
        isUserStopping = false
    }
}

enum CaptureError: Error {
    case micDenied
    case speechDenied
    case onDeviceUnavailable
    case internalError
}

extension DefaultTranscriptionService: @unchecked Sendable {}

extension CaptureError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .micDenied:
            "Microphone permission is denied. Enable microphone access in Settings to record."
        case .speechDenied:
            "Speech Recognition permission is denied. Enable Speech Recognition in Settings to transcribe."
        case .onDeviceUnavailable:
            "On-device transcription isn't available for your language or device. You can still record audio."
        case .internalError:
            "Something went wrong during recording. Please try again."
        }
    }
}
