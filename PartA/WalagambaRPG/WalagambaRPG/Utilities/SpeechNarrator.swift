import AVFoundation

final class SpeechNarrator {

    static let shared = SpeechNarrator()
    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.47
        utterance.pitchMultiplier = 1.05
        synthesizer.speak(utterance)
    }
}
