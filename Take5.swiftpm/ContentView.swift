import SwiftUI

struct ContentView: View {
    // Environment object to track session state
    @EnvironmentObject var sessionData: SessionData
    
    // State variables for controlling UI animations
    @State private var showFirstLine = false
    @State private var showSecondLine = false
    @State private var showThirdLine = false
    @State private var showFourthLine = false
    @State private var showButtons = false
    @State private var showSkipButton = true 
    @State private var firstLineWorkItem: DispatchWorkItem?
    @State private var firstLineHideWorkItem: DispatchWorkItem?
    @State private var secondLineWorkItem: DispatchWorkItem?
    @State private var secondLineHideWorkItem: DispatchWorkItem?
    @State private var thirdLineWorkItem: DispatchWorkItem?
    @State private var thirdLineHideWorkItem: DispatchWorkItem?
    @State private var showAboutInfo = false
    @State private var show5421Info = false
    @State private var showSquareBreathingInfo = false
    @State private var showBubblesInfo = false
    @State private var isModalPresented = false

    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.163, green: 0.004, blue: 0.384), Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    if !sessionData.hasSeenIntro {
                        HStack {
                            
                         Spacer()
                            Button(action: {
                                // Skip intro and set hasSeenIntro to true
                                sessionData.hasSeenIntro = true
                                firstLineWorkItem?.cancel()
                                firstLineHideWorkItem?.cancel()
                                secondLineWorkItem?.cancel()
                                secondLineHideWorkItem?.cancel()
                                thirdLineWorkItem?.cancel()
                                thirdLineHideWorkItem?.cancel()
                                
                                // Hide the skip button and show all intro text at once
                                withAnimation {
                                    showSkipButton = false
                                    showFirstLine = false
                                    showSecondLine = false
                                    showThirdLine = false
                                    showFourthLine = true
                                    showButtons = true
                                    sessionData.hasSeenIntro=true
                                }
                            }) {
                                Text("Skip Intro")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                            }.opacity(showSkipButton ? 1 : 0) // Fade the button out
                                .animation(.easeInOut(duration: 1), value: showSkipButton)
                                .padding(.top, 40)
                        }
                        
                    }else{
                        HStack{
                            Button(action: {
                                isModalPresented = true
                                showAboutInfo = true

                            }) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                                 .font(.system(size: 40))
                                    .padding(.top, 39)
                                    .padding(.leading, 16)
                                
                            }
                            .opacity(showButtons ? 1 : 0)
                            .sheet(isPresented: $showAboutInfo) {
                                InfoView(
                                    title: "About Take 5",
                                    description: "Hi! I'm Fernando. I created this app because I understand how overwhelming stress can be. On this app I've applied 2 grounding techniques (5-4-3-2-1 and Box Breathing) that have personally helped me manage stress and anxiety, and I believe that this app can be an interactive and simple way of giving access to proven methods  of improving your wellness. Grounding techniques can help refocusing on the present moment, and they have great value. I recommend you practice them." ,
                                    description2: "For this app, I made all image designs, and audio (using Garageband for the song, and my mouth fot the bubbles :P). "
                                )
                            }

                            Spacer()

                        }
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Text("Hi, I'm Fernando.")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(.white)
                            .opacity(showFirstLine ? 1 : 0)
                            .animation(.easeInOut(duration: 1), value: showFirstLine)
                            .frame(width: 500, height: 300)
                            .onAppear {
                                if !sessionData.hasSeenIntro {
                                    firstLineWorkItem = DispatchWorkItem {
                                        withAnimation { showFirstLine = true }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: firstLineWorkItem!)
                                    
                                    firstLineHideWorkItem = DispatchWorkItem {
                                        withAnimation { showFirstLine = false }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.6, execute: firstLineHideWorkItem!)
                                }
                            }
                        
                        Text("Sometimes, I feel too much stress, and I can't focus on today.")
                            .font(.system(size: 30, weight: .regular))
                            .foregroundColor(.white)
                            .opacity(showSecondLine ? 1 : 0)
                            .animation(.easeInOut(duration: 1), value: showSecondLine)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .frame(width: 500, height: 300)
                            .onAppear {
                                if !sessionData.hasSeenIntro {
                                    secondLineWorkItem = DispatchWorkItem {
                                        withAnimation { showSecondLine = true }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.1, execute: secondLineWorkItem!)
                                    
                                    secondLineHideWorkItem = DispatchWorkItem {
                                        withAnimation { showSecondLine = false }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.7, execute: secondLineHideWorkItem!)
                                }
                            }

                        
                        Text("Here are some methods that help me relax, I hope they help you :)")
                            .font(.system(size: 30, weight: .regular))
                            .foregroundColor(.white)
                            .opacity(showThirdLine ? 1 : 0)
                            .animation(.easeInOut(duration: 1), value: showThirdLine)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .frame(width: 500, height: 300)
                            .onAppear {
                                if !sessionData.hasSeenIntro {
                                    thirdLineWorkItem = DispatchWorkItem {
                                        withAnimation { showThirdLine = true }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: thirdLineWorkItem!)
                                    
                                    thirdLineHideWorkItem = DispatchWorkItem {
                                        withAnimation { showThirdLine = false }
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 11, execute: thirdLineHideWorkItem!)
                                }
                            }
                        
                        Text("Let's take 5")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(showFourthLine ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showFourthLine)
                            .onAppear {
                                if sessionData.hasSeenIntro {
                                    showFourthLine = true
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                                        withAnimation { showFourthLine = true }
                                    }
                                }
                            }
                    }
                    
                    HStack {
                        VStack(spacing: 5) {
                            NavigationLink(destination: My5to1View()) {
                                ZStack {
                                    Image("button2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 150)
                                    
                                    Text("5-4-3-2-1 Method")
                                        .font(.title)
                                        .foregroundColor(.indigo)
                                        .bold()
                                        .frame(width: 200, height: 150)
                                }
                            }
                            
                            Button(action: {
                                show5421Info = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                            .sheet(isPresented: $show5421Info) {
                                InfoView(
                                    title: "5-4-3-2-1 Method",
                                    description: "A sensory grounding technique that uses your senses to help you focus on the present moment. Name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, and 1 you can taste.  ",
                                    description2:"The 5-4-3-2-1 grounding technique offers several benefits, including reducing anxiety by interrupting anxious thought spirals and improving mindfulness by promoting awareness of our surroundings. It helps regulate emotions, fostering a calmer response to stress and anxiety. Engaging the senses also activates the parasympathetic nervous system, aiding relaxation and countering the fight-or-flight response."
                                )
                            }
                        }
                        
                        
                        // Square Breathing Button and Info
                        VStack(spacing: 5) {
                            NavigationLink(destination: SquareBreathView()) {
                                ZStack {
                                    Image("button2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 150)
                                    
                                    Text("Box Breathing")
                                        .font(.title)
                                        .foregroundColor(.indigo)
                                        .bold()
                                        .frame(width: 200, height: 150)
                                }
                            }
                            
                            Button(action: {
                                showSquareBreathingInfo = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                            .sheet(isPresented: $showSquareBreathingInfo) {
                                InfoView(
                                    title: "Box Breathing",
                                    description: "A calming breathing technique where you breathe in for 4 counts, hold for 4, exhale for 4, and hold for 4. This pattern helps reduce stress and improve focus. Box breathing is a deep breathing technique that helps reduce stress, manage anxiety, and lower blood pressure. ",
                                    description2:" Regular practice can enhance overall well-being, making it an effective tool for mental and physical health. If you become breathless or dizzy, stop immediately and resume regular breathing."
                                )
                            }
                        }
                        
                        
                        // Pop Bubbles Button and Info
                        VStack(spacing: 5) {
                            NavigationLink(destination: BubbleGameView()) {
                                ZStack {
                                    Image("button2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 150)
                                    
                                    Text("Pop bubbles")
                                        .font(.title)
                                        .foregroundColor(.indigo)
                                        .bold()
                                }
                            }
                            
                            Button(action: {
                                showBubblesInfo = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                            }
                            .sheet(isPresented: $showBubblesInfo) {
                                InfoView(
                                    title: "Pop Bubbles",
                                    description: "A simple clicker game I added for fun. Popping bubbles can be surprisingly calming and helps redirect your attention from stress.Hope u like the sound. Try getting a cool highscore!",
                                    description2:""
                                )
                            }
                        }
                        
                        
                    }
                    .animation(.easeIn(duration: 1), value: showButtons)
                        .onAppear {
                            if sessionData.hasSeenIntro {
                                showButtons = true
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 12.5) {
                                    withAnimation { showButtons = true }
                                }
                            }
                        }
                        .opacity(showButtons ? 1 : 0)
                    Spacer()
                }
                .padding()
                .onAppear {
                    if !sessionData.hasSeenIntro {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                            sessionData.hasSeenIntro = true
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
