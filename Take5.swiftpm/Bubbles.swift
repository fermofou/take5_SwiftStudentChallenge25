import SwiftUI
import AVFoundation

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    var speed: CGFloat
    var size: CGFloat
}

struct BubbleGameView: View {
    @State private var bubbles: [Bubble] = []
    @State private var score = 0
    @State private var funMessages = ["yo, u are really good at this!", "u r locked in!", "relax chillax", "im kinda hungry...", "i really like dr pepper", "dont miss that bubble, yea that one", "You like the music? I made it with Apple Loops:)"]
    @State private var currentMessage = ""
    @State private var showMessage = false
    @State private var currentGradientIndex = 0
    @State private var gradientProgress: CGFloat = 0
    
    @State private var bubbleSound: AVAudioPlayer?
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    let palette = [
        Color(red: 1/255, green: 42/255, blue: 74/255),
        Color(red: 1/255, green: 58/255, blue: 99/255),
        Color(red: 1/255, green: 73/255, blue: 124/255),
        Color(red: 1/255, green: 79/255, blue: 134/255),
        Color(red: 42/255, green: 111/255, blue: 151/255),
        Color(red: 44/255, green: 125/255, blue: 160/255),
        Color(red: 70/255, green: 143/255, blue: 175/255),
        Color(red: 97/255, green: 165/255, blue: 194/255),
        Color(red: 137/255, green: 194/255, blue: 217/255),
        Color(red: 169/255, green: 214/255, blue: 229/255)
    ]
    
    @AppStorage("highScore") private var highScore = 0  // Use @AppStorage to automatically sync with UserDefaults
    
    var currentGradientColors: [Color] {
        let currentColor = palette[currentGradientIndex]
        let nextColor = palette[(currentGradientIndex + 1) % palette.count]
        return [
            Color.interpolate(from: currentColor, to: nextColor, progress: gradientProgress),
            Color.interpolate(from: palette[(currentGradientIndex + 1) % palette.count], 
                              to: palette[(currentGradientIndex + 2) % palette.count], 
                              progress: gradientProgress)
        ]
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: currentGradientColors), 
                           startPoint: .top, 
                           endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            .animation(.linear(duration: 0.1), value: gradientProgress)
            
            ForEach(bubbles) { bubble in
                Image("bubble")
                    .resizable()
                    .scaledToFit()
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .onTapGesture {
                        popBubble(bubble)
                    }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Text("Highscore: \(highScore)")
                        .font(.title)
                        .bold()
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                
                if showMessage {
                    Text(currentMessage)
                        .font(.title2)
                        .foregroundColor(.white)
                        .transition(.opacity)
                }
            }
            .padding(.top, 40)
        }
        .onAppear {
            setupAudio()
            startGame()
        }
        .onDisappear {
            saveScore()  // Ensure high score is saved when game ends
        }
    }
    
    func setupAudio() {
        // Setup audio player once and keep it ready
        guard let soundURL = Bundle.main.url(forResource: "pop", withExtension: "m4a") else { return }
        do {
            bubbleSound = try AVAudioPlayer(contentsOf: soundURL)
            bubbleSound?.prepareToPlay() // Preload the audio
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
    
    func startGame() {
        score = 0
        
        // Bubble generation timer
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { timer in
            let randomSize = CGFloat.random(in: 60...190)
            let newBubble = Bubble(
                position: CGPoint(x: CGFloat.random(in: 50...screenWidth - 50), y: screenHeight),
                speed: CGFloat.random(in: 2...5),
                size: randomSize
            )
            bubbles.append(newBubble)
        }
        
        // Messages timer
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            currentMessage = funMessages.randomElement() ?? ""
            withAnimation {
                showMessage = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    showMessage = false
                }
            }
        }
        
        // Bubble movement timer
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            bubbles = bubbles.map { bubble in
                var newBubble = bubble
                newBubble.position.y -= newBubble.speed
                return newBubble
            }
            bubbles.removeAll { $0.position.y < 0 }
        }
        
        // Smooth gradient animation timer
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            withAnimation {
                gradientProgress += 0.01
                if gradientProgress >= 1.0 {
                    gradientProgress = 0
                    currentGradientIndex = (currentGradientIndex + 1) % palette.count
                }
            }
        }
    }
    
    func popBubble(_ bubble: Bubble) {
        if let index = bubbles.firstIndex(where: { $0.id == bubble.id }) {
            bubbles.remove(at: index)
            score += 1
            
            // Update high score if necessary
            if score > highScore {
                highScore = score
            }
            
            // Reset and play sound
            bubbleSound?.stop()
            bubbleSound?.currentTime = 0
            bubbleSound?.play()
        }
    }
    
    func saveScore() {
        // Ensures high score is saved at the end of the game, though @AppStorage automatically handles updates
        if score > highScore {
            highScore = score
        }
    }
}

// Extension to interpolate between colors
extension Color {
    static func interpolate(from: Color, to: Color, progress: CGFloat) -> Color {
        let fromComponents = from.components
        let toComponents = to.components
        
        return Color(
            red: fromComponents.red + (toComponents.red - fromComponents.red) * Double(progress),
            green: fromComponents.green + (toComponents.green - fromComponents.green) * Double(progress),
            blue: fromComponents.blue + (toComponents.blue - fromComponents.blue) * Double(progress)
        )
    }
    
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        
        return (Double(r), Double(g), Double(b), Double(o))
    }
}

struct BubbleGameView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleGameView()
    }
}
