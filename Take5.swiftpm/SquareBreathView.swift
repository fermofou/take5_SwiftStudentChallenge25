import SwiftUI

class BreathingCycleManager: ObservableObject {
    struct BreathingPhase {
        let name: String
        let duration: Double
        let targetScale: CGFloat
        let targetColor: Color
        let targetBallProgress: CGFloat
    }
    
    let phases: [BreathingPhase] = [
        BreathingPhase(
            name: "Inhale",
            duration: 4.0,
            targetScale: 1.4,
            targetColor: Color(red: 0.7, green: 0.85, blue: 0.95),
            targetBallProgress: 0.25  // Move to right
        ),
        BreathingPhase(
            name: "Hold",
            duration: 4.0,
            targetScale: 1.4,
            targetColor: Color(red: 0.8, green: 0.95, blue: 0.8),
            targetBallProgress: 0.5   // Move down
        ),
        BreathingPhase(
            name: "Exhale",
            duration: 4.0,
            targetScale: 1.0,
            targetColor: Color(red: 0.9, green: 0.8, blue: 0.9),
            targetBallProgress: 0.75  // Move left
        ),
        BreathingPhase(
            name: "Hold",
            duration: 4.0,
            targetScale: 1.0,
            targetColor: Color(red: 0.95, green: 0.9, blue: 0.8),
            targetBallProgress: 1.0   // Move up
        )
    ]
    
    @Published var currentPhaseName: String
    @Published var currentScale: CGFloat   
    @Published var currentColor: Color
    @Published var ballProgress: CGFloat = 0
    @Published var isFinished = false
    @Published var totalCycles = 0
    @Published var currentFact: String
    
    init() {
        // Set initial values to prevent animation
        currentPhaseName = phases[0].name
        currentScale = phases[0].targetScale
        currentColor = phases[0].targetColor
        ballProgress = 0  // Start at top-left
        currentFact = "Box breathing can help reduce anxiety"
    }
    
    private var currentPhaseIndex = 0
    private var startTime: Date?
    private let totalDuration: Double = 120.0
    
    let facts = [
        "Box breathing can help reduce anxiety",
        "Navy SEALs use this technique for stress management",
        "Regular practice can lower blood pressure",
        "It helps improve focus and concentration",
        "Also known as '4x4 breathing'",
        "Can help with better sleep quality",
        "Reduces stress hormone cortisol levels",
        "Helps activate your parasympathetic system",
        "Can be done anywhere, anytime",
        "Improves emotional regulation"
    ]
    
    func start() {
        startTime = Date()
        updatePhase(index: currentPhaseIndex)
    }
    
    private func updatePhase(index: Int) {
        guard let startTime = startTime else { return }
        if Date().timeIntervalSince(startTime) >= totalDuration {
            finish()
            return
        }
        
        let phase = phases[index]
        withAnimation(.easeInOut(duration: phase.duration)) {
            self.currentScale = phase.targetScale
            self.currentColor = phase.targetColor
            self.ballProgress = phase.targetBallProgress
        }
        
        // Update phase name without animation
        self.currentPhaseName = phase.name
        
        DispatchQueue.main.asyncAfter(deadline: .now() + phase.duration) {
            let nextIndex = (index + 1) % self.phases.count
            if nextIndex == 0 {
                self.totalCycles += 1
                self.updateFact()
                
            }
            
            self.currentPhaseIndex = nextIndex
            self.updatePhase(index: nextIndex)
        }
    }
    
    private func updateFact() {
        currentFact = facts[totalCycles % facts.count]
    }
    
    private func finish() {
        isFinished = true
    }
}

struct SquareBreathView: View {
    @StateObject private var manager = BreathingCycleManager()
    
    private let squareSize: CGFloat = 200
    private let ballSize: CGFloat = 20
    private let circleFrameSize: CGFloat = 140
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.indigo]),
                               startPoint: .leading,
                               endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
                
                if manager.isFinished {
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        Text("Well done!")
                            .font(.title)
                            .bold()
                        Text("Want to pop some bubbles?")
                            .font(.title2)
                            .padding()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                    }
                } else {
                    VStack(spacing: 20) {
                        Spacer()
                        Text(manager.currentFact)
                            .font(.title)
                            
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: 60)
                            .animation(nil)  
                        
                        Text(manager.currentPhaseName)
                            .font(.system(size: 70))                           .foregroundColor(.white)
                            .bold()
                            .animation(nil)  
                        
                        
                        ZStack (alignment: .center){
                            Rectangle()
                                .stroke(manager.currentColor, lineWidth: 5)
                                .frame(width: squareSize, height: squareSize)
                            
                            Circle()
                                .fill(manager.currentColor)
                                .frame(width: ballSize, height: ballSize)
                                .position(getBallPosition(progress: manager.ballProgress))
                            
                            Circle()
                                .fill(manager.currentColor.opacity(0.5))
                                .frame(
                                    width: (manager.ballProgress == 0 ? circleFrameSize * 0.5 : circleFrameSize * manager.currentScale),
                                    height: (manager.ballProgress == 0 ? circleFrameSize * 0.5 : circleFrameSize * manager.currentScale)
                                )
                                
                        }
                        .frame(width: squareSize, height: squareSize)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }
        .onAppear {
            manager.start()
        }
    }
    
    private func getBallPosition(progress: CGFloat) -> CGPoint {
        let trackLength = squareSize - ballSize
        let margin = ballSize / 2
        
        // Now each phase moves to a corner
        if progress == 0 {
            return CGPoint(x: margin-10, y: margin-10)  // Top-left
        } else if progress == 0.25 {
            return CGPoint(x: squareSize - margin+10, y: margin-10)  // Top-right
        } else if progress == 0.5 {
            return CGPoint(x: squareSize - margin+10, y: squareSize - margin+10)  // Bottom-right
        } else if progress == 0.75 {
            return CGPoint(x: margin-10, y: squareSize - margin+10)  // Bottom-left
        } else if progress == 1.0 {
            return CGPoint(x: margin-10, y: margin-10)  // Back to top-left
        }
        
        //calculate based on which side we're on
        if progress < 0.25 {
            // Moving right along top
            let x = margin + (trackLength * (progress / 0.25))
            return CGPoint(x: x, y: margin)
        } else if progress < 0.5 {
            // Moving down along right side
            let y = margin + (trackLength * ((progress - 0.25) / 0.25))
            return CGPoint(x: squareSize - margin, y: y)
        } else if progress < 0.75 {
            // Moving left along bottom
            let x = squareSize - margin - (trackLength * ((progress - 0.5) / 0.25))
            return CGPoint(x: x, y: squareSize - margin)
        } else {
            // Moving up along left side
            let y = squareSize - margin - (trackLength * ((progress - 0.75) / 0.25))
            return CGPoint(x: margin, y: y)
        }
    }
}
