internal import AVFAudio
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
    private var audioFile: AVAudioFile?
    private var currentFileURL: URL?
    private var writer: AudioBufferWriter?
    private var interruptionObserver: Any?
    private var routeObserver: Any?

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
            // feed recognizer
            self?.recognitionRequest?.append(buffer)
            // Offload file writes off the realtime thread
            self?.enqueueWrite(buffer: buffer)
        }

        audioEngine.prepare()
        try prepareRecordingFile(with: recordingFormat)
        try audioEngine.start()
        Logger.capture.log("Audio engine started, onDeviceOnly=\(onDeviceOnly)")

        observeAudioSessionNotifications()

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
        audioFile = nil
        writer = nil
        // Keep currentFileURL so the caller can associate it with a saved entry after stop
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        Logger.capture.log("Audio engine stopped")
        isUserStopping = false

        // Remove observers
        if let o = interruptionObserver { NotificationCenter.default.removeObserver(o); interruptionObserver = nil }
        if let o = routeObserver { NotificationCenter.default.removeObserver(o); routeObserver = nil }
    }

    private func prepareRecordingFile(with format: AVAudioFormat) throws {
        let dir = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("Audio", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
        // Set file protection and exclude from backups
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try? (dir as NSURL).setResourceValue(true, forKey: .isExcludedFromBackupKey)
        // Note: NSFileProtection is set via attributes when creating file; we'll set after opening too
        // Use a broadly compatible output format for playback: 16-bit PCM, mono, interleaved, preserve sample rate
        guard let outFormat = AVAudioFormat(commonFormat: .pcmFormatInt16,
                                            sampleRate: format.sampleRate,
                                            channels: 1,
                                            interleaved: true) else { throw CaptureError.internalError }
        audioFile = try AVAudioFile(forWriting: url, settings: outFormat.settings)
        currentFileURL = url
        if let file = audioFile { writer = AudioBufferWriter(file: file) }
        // Strengthen on-disk protection (best-effort)
        do {
            try FileManager.default.setAttributes([
                .protectionKey: FileProtectionType.completeUntilFirstUserAuthentication,
            ], ofItemAtPath: url.path)
        } catch {
            // best-effort; ignore
        }
    }

    func startAudioOnlyRecording() async throws {
        if audioEngine.isRunning { await stop() }
        didCleanup = false
        isUserStopping = false
        try configureAudioSession()
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.enqueueWrite(buffer: buffer)
        }
        try prepareRecordingFile(with: format)
        try audioEngine.start()
        Logger.capture.log("Audio-only recording started")
    }

    func currentRecordingFileURL() -> URL? { currentFileURL }

    private func enqueueWrite(buffer: AVAudioPCMBuffer) {
        guard let writer else { return }
        // Copy buffer to detach from realtime memory
        guard let copy = AVAudioPCMBuffer(pcmFormat: buffer.format, frameCapacity: buffer.frameLength) else { return }
        copy.frameLength = buffer.frameLength
        let channels = Int(buffer.format.channelCount)
        if let src = buffer.floatChannelData, let dst = copy.floatChannelData {
            for ch in 0 ..< channels {
                memcpy(dst[ch], src[ch], Int(buffer.frameLength) * MemoryLayout<Float>.size)
            }
        } else if let srcI16 = buffer.int16ChannelData, let dstI16 = copy.int16ChannelData {
            for ch in 0 ..< channels {
                memcpy(dstI16[ch], srcI16[ch], Int(buffer.frameLength) * MemoryLayout<Int16>.size)
            }
        }
        Task { await writer.write(copy) }
    }

    private func observeAudioSessionNotifications() {
        let center = NotificationCenter.default
        interruptionObserver = center.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: .main) { [weak self] note in
            guard let self else { return }
            let userInfo = note.userInfo ?? [:]
            if let typeRaw = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
               let type = AVAudioSession.InterruptionType(rawValue: typeRaw)
            {
                switch type {
                case .began:
                    Task { await self.stop() }
                case .ended:
                    // Do nothing; the view decides whether to resume
                    break
                @unknown default:
                    break
                }
            } else {
                // Conservative: stop on unknown interruption
                Task { await self.stop() }
            }
        }
        routeObserver = center.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main) { [weak self] note in
            guard let self else { return }
            let userInfo = note.userInfo ?? [:]
            if let reasonRaw = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
               let reason = AVAudioSession.RouteChangeReason(rawValue: reasonRaw)
            {
                if reason == .oldDeviceUnavailable || reason == .categoryChange {
                    Task { await self.stop() }
                }
            }
        }
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

// MARK: - Async writer to avoid blocking realtime audio thread

private actor AudioBufferWriter {
    private let file: AVAudioFile
    init(file: AVAudioFile) { self.file = file }
    func write(_ buffer: AVAudioPCMBuffer) async {
        do { try file.write(from: buffer) } catch {
            await Logger.capture.error("Audio write failed: \(error.localizedDescription, privacy: .public)")
        }
    }
}
