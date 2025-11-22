import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    private init() {}

    func playSound(_ name: String, type: String = "mp3") {
        guard let url = Bundle.main.url(forResource: name, withExtension: type) else {
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Failed to play sound \(name): \(error.localizedDescription)")
        }
    }
}
