import AVFoundation

class NarrationManager {

    static let shared = NarrationManager()

    private var narrationPlayer: AVAudioPlayer?
    private var backgroundPlayer: AVAudioPlayer?

    func playNarration(_ file: String) {
        if let url = Bundle.main.url(forResource: file, withExtension: "mp3") {
            narrationPlayer = try? AVAudioPlayer(contentsOf: url)
            narrationPlayer?.play()
        }
    }

    func playBackgroundLoop(_ file: String) {
        if let url = Bundle.main.url(forResource: file, withExtension: "mp3") {
            backgroundPlayer = try? AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1
            backgroundPlayer?.play()
        }
    }

    func stopBackground() {
        backgroundPlayer?.stop()
    }
}
