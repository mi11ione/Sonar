internal import AVFAudio
import Foundation

protocol TextToSpeechService: Sendable {
    func availableVoices() -> [AVSpeechSynthesisVoice]
    func speak(_ text: String, voice: AVSpeechSynthesisVoice?, rate: Float, pitch: Float)
    func stop()
}

final class DefaultTextToSpeechService: NSObject, TextToSpeechService, @unchecked Sendable {
    private let synthesizer = AVSpeechSynthesizer()

    func availableVoices() -> [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices()
    }

    func speak(_ text: String, voice: AVSpeechSynthesisVoice?, rate: Float, pitch: Float) {
        let utterance = AVSpeechUtterance(string: text)
        if let voice { utterance.voice = voice }
        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
