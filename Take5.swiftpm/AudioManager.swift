import SwiftUI
import AVFoundation

class AudioPlayerManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    
    func startLoopingSong() {
        if let path = Bundle.main.path(forResource: "My Song", ofType: "m4a") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1 // Loop indefinitely
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error)")
            }
        }
    }
    
    func stopSong() {
        audioPlayer?.stop()
    }
}

