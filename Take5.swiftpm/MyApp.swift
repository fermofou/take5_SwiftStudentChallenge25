import SwiftUI

@main
struct YourApp: App {
    @StateObject var sessionData = SessionData() // var
    @StateObject var audioPlayerManager = AudioPlayerManager() //  audio manager

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionData) 
                .onAppear {
                    // Start the song when the content view appears
                    audioPlayerManager.startLoopingSong()
                }
                .onDisappear {
                    audioPlayerManager.stopSong()
                }
        }
    }
}

