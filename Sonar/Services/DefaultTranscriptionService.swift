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
    private var amplitudeContinuation: AsyncStream<Float>.Continuation?
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

        // Microphone authorization (AVAudioApplication in iOS 17+)
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
            self?.yieldAmplitude(from: buffer)
        }

        audioEngine.prepare()
        try prepareRecordingFile(with: recordingFormat)
        do {
            try audioEngine.start()
        } catch {
            Logger.capture.error("Audio engine failed to start: \(error.localizedDescription, privacy: .public)")
            throw error
        }
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
                    // Do not immediately finish the stream; allow caller to decide. Stop engine though.
                    Task { await self?.stop() }
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
        // Allow recording to continue with screen off; prefer balanced options for capture
        try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetoothHFP, .allowBluetoothA2DP, .mixWithOthers])
        try session.setActive(true, options: [.notifyOthersOnDeactivation])
    }

    private func cleanupRecognition() {
        if didCleanup { return }
        didCleanup = true
        recognitionTask = nil
        recognitionRequest = nil
        streamContinuation = nil
        amplitudeContinuation?.finish(); amplitudeContinuation = nil
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
        // Match file format to capture format to avoid real-time conversion complexity
        audioFile = try AVAudioFile(forWriting: url, settings: format.settings)
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
            self?.yieldAmplitude(from: buffer)
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
                    // Pause engine but keep recognition alive in case it resumes
                    Task { @MainActor in
                        if self.audioEngine.isRunning {
                            self.audioEngine.pause()
                        }
                    }
                case .ended:
                    // Attempt to resume engine after interruption ends
                    Task { @MainActor in
                        do { try self.audioEngine.start() } catch {}
                    }
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
                // Only stop when the previous device became unavailable (e.g., unplugged headphones)
                if reason == .oldDeviceUnavailable {
                    Task { await self.stop() }
                }
            }
        }
    }

    // MARK: - Amplitude meter

    func amplitudeStream() -> AsyncStream<Float> {
        AsyncStream<Float> { continuation in
            self.amplitudeContinuation = continuation
            continuation.onTermination = { [weak self] _ in
                Task { @MainActor in self?.amplitudeContinuation = nil }
            }
        }
    }

    private func yieldAmplitude(from buffer: AVAudioPCMBuffer) {
        guard let continuation = amplitudeContinuation else { return }
        // Prefer float data; otherwise convert from Int16
        var rms: Float = 0
        if let floatData = buffer.floatChannelData {
            let channel = floatData[0]
            let frameCount = Int(buffer.frameLength)
            if frameCount > 0 {
                var sum: Float = 0
                var i = 0
                while i < frameCount {
                    let s = channel[i]
                    sum += s * s
                    i += 1
                }
                rms = sqrtf(sum / Float(frameCount))
            }
        } else if let int16Data = buffer.int16ChannelData {
            let channel = int16Data[0]
            let frameCount = Int(buffer.frameLength)
            if frameCount > 0 {
                var sum: Float = 0
                let scale: Float = 1.0 / 32768.0
                var i = 0
                while i < frameCount {
                    let s = Float(channel[i]) * scale
                    sum += s * s
                    i += 1
                }
                rms = sqrtf(sum / Float(frameCount))
            }
        }
        // Simple peak emphasis and clamp to [0,1]
        let level = min(max(rms * 1.8, 0), 1)
        continuation.yield(level)
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
            String(localized: "err_mic_denied")
        case .speechDenied:
            String(localized: "err_speech_denied")
        case .onDeviceUnavailable:
            String(localized: "err_ondevice_unavailable")
        case .internalError:
            String(localized: "err_generic_recording")
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
