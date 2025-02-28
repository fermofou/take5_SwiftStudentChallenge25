import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    let description: String
    let description2: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.163, green: 0.004, blue: 0.384), Color.blue]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                Text(description)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                Text(description2)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 15)

                
                Spacer()
                
                Button("Close") {
                    dismiss()
                }
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)
                .padding(.bottom, 40)
            }
        }
    }
}
