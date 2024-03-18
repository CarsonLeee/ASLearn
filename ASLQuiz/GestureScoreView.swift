import SwiftUI

struct GestureScoreView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.black, Color(#colorLiteral(red: 0, green: 57/255, blue: 89/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Game Over")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("Score: \(viewModel.score)")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Button("Play Again") {
                    viewModel.score = 0 // Reset score
                    viewModel.currentScreen = .gestureGame // Restart the gesture game
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#030d13"))
                .foregroundColor(Color(hex: "#0066ff"))
                .cornerRadius(10)
                .padding(.horizontal)
                .fontWeight(.bold)
                
                Button("Home") {
                    viewModel.currentScreen = .home // Navigate back to the home view
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#030d13"))
                .foregroundColor(Color(hex: "#0066ff"))
                .cornerRadius(10)
                .padding(.horizontal)
                .fontWeight(.bold)
            }
        }
    }
}

struct GestureScoreView_Previews: PreviewProvider {
    static var previews: some View {
        GestureScoreView(viewModel: AppViewModel())
    }
}
