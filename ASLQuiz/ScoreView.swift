import Foundation
import SwiftUI

struct ScoreView: View {
    @ObservedObject var viewModel: AppViewModel
    var score: Int
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.black, Color(#colorLiteral(red: 0, green: 57/255, blue: 89/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Game Over")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                
                Text("Score: \(viewModel.score)") // This now automatically updates
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Button("Play Again") {
                    // Reset the game or navigate as needed
                    viewModel.currentScreen = .game // Assumes you have logic to reset the game state
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#030d13")) // Custom color
                .foregroundColor(Color(hex: "#0066ff"))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 100)
                .fontWeight(.bold)
                
                Button("Home") {
                    // Navigate back to the home view
                    viewModel.currentScreen = .home
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#030d13")) // Custom color
                .foregroundColor(Color(hex: "#0066ff"))
                .cornerRadius(10)
                .padding(.horizontal)
                .fontWeight(.bold)
            }
        }
    }
}

// Preview modification
struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(viewModel: AppViewModel(), score: 5)
    }
}

// Color extension to support hex values
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
