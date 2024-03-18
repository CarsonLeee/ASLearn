import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    enum Screen {
        case home
        case game
        case score
        case howToPlay
        case gestureGame
        case gestureScore // New case for GestureScoreView
        // Add any other cases as needed
    }
    
    @Published var currentScreen: Screen = .home
    @Published var score: Int = 0
    
    // Add functions or additional properties as needed
}
