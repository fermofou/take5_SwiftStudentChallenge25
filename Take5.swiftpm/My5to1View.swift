import SwiftUI

struct My5to1View: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentStep = 0
    @State private var countdown = [5, 4, 3, 2, 1] 
    @State private var buttonText = "5"
    @State private var isComplete = false
    @State private var showCountdownButton = false 
    
    // List of countdowns per step
    let countdownSteps: [[Int]] = [
        [5, 4, 3, 2, 1],   // 5 Things You See
        [4, 3, 2, 1],       // 4 Things You feel
        [3, 2, 1],         // 3 Things You hear
        [2, 1],            // 2 Things You smell
        [1]                // 1 Thing You taste
    ]
    
    // Sensory images and text for each step
    let sensoryInfo: [(imageName: String, text: String)] = [
        ("eye", "5 things you can see"),
        ("touch", "4 things you can feel"),
        ("ear", "3 things you can hear"),
        ("nose", "2 things you can smell"),
        ("mouth", "1 thing you can touch")
    ]
    
    let colors: [Int: Color] = [
        5: Color(red: 1/255, green: 42/255, blue: 74/255),
        4: Color(red: 1/255, green: 79/255, blue: 134/255),
        3: Color(red: 44/255, green: 125/255, blue: 160/255),
        2: Color(red: 97/255, green: 165/255, blue: 194/255),
        1: Color(red: 169/255, green: 214/255, blue: 229/255)
    ]

    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.indigo]),
                           startPoint: .leading,
                           endPoint: .trailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                if !isComplete {
                    if showCountdownButton {
                        // Countdown view: show the sensory text at the top, then the button
                        if let sensoryData = sensoryInfo[safe: currentStep] {
                            Text(sensoryData.text)
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                        }
                        Button(action: handleCountdown) {
                            Text(buttonText)
                                .font(.system(size: 80, weight: .bold))
                                .frame(width: 200, height: 200)  
                                .background(colors[countdown.first ?? 1, default: .white]) // Fix: Access first number
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .transition(.scale)
                    } else {
                        // Sensory view: show full image and text immediately
                        if let sensoryData = sensoryInfo[safe: currentStep] {
                            Image(sensoryData.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .opacity(0.7)
                                .transition(.opacity)
                            
                            Text(sensoryData.text)
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                                .opacity(0.7)
                                .transition(.opacity)
                        }
                    }
                } else {
                    // Completion view
                    Text("Well done! 🥳 Want to breath together a little? ")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                }
                
                Spacer()
            }
        }
        .onAppear {
            // For the very first step, show the countdown button after 2 seconds.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showCountdownButton = true
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showCountdownButton)
    }
    
    // Handles countdown and step transitions
    func handleCountdown() {
        if countdown.count == 1 {
            // Hide the countdown button so the sensory view (image and text) is updated off-screen.
            withAnimation {
                showCountdownButton = false
            }
            if currentStep < countdownSteps.count - 1 {
                currentStep += 1
                countdown = countdownSteps[currentStep]
                buttonText = "\(countdown.first!)"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showCountdownButton = true
                    }
                }
            } else {
                isComplete = true // All steps completed
            }
        } else {
            countdown.removeFirst()
            if let nextNumber = countdown.first {
                buttonText = "\(nextNumber)"
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}

struct My5to1View_Previews: PreviewProvider {
    static var previews: some View {
        My5to1View()
    }
}
