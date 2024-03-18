import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = AppViewModel() // Assuming AppViewModel is defined elsewhere
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: Color.black, location: 0),
                    .init(color: Color(#colorLiteral(red: 0, green: 40/255, blue: 63/255, alpha: 1)), location: 0.4),
                    .init(color: Color(#colorLiteral(red: 0, green: 40/255, blue: 63/255, alpha: 1)), location: 0.5),
                    .init(color: Color(#colorLiteral(red: 0, green: 57/255, blue: 89/255, alpha: 1)), location: 1)
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    if viewModel.currentScreen == .home {
    
                        Spacer()
                        
                        Image("AppLogo") // Use your app's icon image
                            .scaledToFit()
                            .frame(width: 120, height: 120) // Reduced size for a better fit
                            .padding(.bottom, 200) // Increase bottom padding to push it up a bit
                            .padding(.top, 150) // Increase top padding for more space from the title


                        
                        // Play Button
                        Button("Gesture Guess") {
                            viewModel.currentScreen = .game
                        }
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 102/255, blue: 255/255, alpha: 1)))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(#colorLiteral(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // ASL Hand game
                        Button("Sign Sculptor") {
                            viewModel.currentScreen = .gestureGame
                        }
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 102/255, blue: 255/255, alpha: 1)))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(#colorLiteral(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        
                        // How to Play Link (Placeholder for actual navigation)
                        Button("How to play?") {
                            viewModel.currentScreen = .howToPlay
                        }
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 102/255, blue: 255/255, alpha: 1)))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(#colorLiteral(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                
                // Conditionally display GameView or ScoreView based on viewModel.currentScreen
                
                if viewModel.currentScreen == .game {
                    GameView(viewModel: viewModel)
                } else if viewModel.currentScreen == .score {
                    ScoreView(viewModel: viewModel, score: 0) // Ensure ScoreView accepts viewModel and score
                } else if viewModel.currentScreen == .howToPlay {
                    HowToPlayView(viewModel: viewModel)
                } else if viewModel.currentScreen == .gestureGame {
                    // Make sure you initialize CameraManager and pass it to GestureRecognitionGameView
                    GestureRecognitionGameView(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                } else if viewModel.currentScreen == .gestureScore {
                    GestureScoreView(viewModel: viewModel)
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
