import SwiftUI

/// This manager drives the breathing cycle. It updates the published properties
/// that both animations use. Each phase lasts 4 seconds, and the cycle repeats.
class BreathingCycleManager: ObservableObject {
    
    /// A breathing phase defines the target values for this phase.
    struct BreathingPhase {
        let name: String
        let duration: Double
        let targetScale: CGFloat
        let targetColor: Color
        let targetBallProgress: CGFloat
    }
    
    /// The four phases: Inhale, Hold (after inhale), Exhale, Hold (after exhale)
    let phases: [BreathingPhase] = [
        BreathingPhase(name: "Inhale", duration: 4.0,
                       targetScale: 1.4,
                       targetColor: Color(red: 0.7, green: 0.85, blue: 0.95),
                       targetBallProgress: 1.0),
        BreathingPhase(name: "Hold", duration: 4.0,
                       targetScale: 1.4,
                       targetColor: Color(red: 0.8, green: 0.95, blue: 0.8),
                       targetBallProgress: 1.0),
        BreathingPhase(name: "Exhale", duration: 4.0,
                       targetScale: 1.0,
                       targetColor: Color(red: 0.9, green: 0.8, blue: 0.9),
                       targetBallProgress: 0.0),
        BreathingPhase(name: "Hold", duration: 4.0,
                       targetScale: 1.0,
                       targetColor: Color(red: 0.95, green: 0.9, blue: 0.8),
                       targetBallProgress: 0.0)
    ]
    
    @Published var currentPhaseName: String = ""
    @Published var currentScale: CGFloat = 1.0
    @Published var currentColor: Color = Color(red: 0.95, green: 0.9, blue: 0.8)
    /// ballProgress is a value between 0.0 and 1.0.
    @Published var ballProgress: CGFloat = 0.0
    
    private var currentPhaseIndex = 0
    
    /// Starts the cycle.
    func start() {
        updatePhase(index: currentPhaseIndex)
    }
    
    /// Recursively updates the cycle, animating to the target values for the current phase.
    private func updatePhase(index: Int) {
        let phase = phases[index]
        withAnimation(.easeInOut(duration: phase.duration)) {
            self.currentScale = phase.targetScale
            self.currentColor = phase.targetColor
            self.currentPhaseName = phase.name
            self.ballProgress = phase.targetBallProgress
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + phase.duration) {
            let nextIndex = (index + 1) % self.phases.count
            self.currentPhaseIndex = nextIndex
            self.updatePhase(index: nextIndex)
        }
    }
}
