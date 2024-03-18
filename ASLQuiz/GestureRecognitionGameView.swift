import SwiftUI
import AVFoundation
import Combine

struct GestureRecognitionGameView: View {
    @StateObject var cameraManager = CameraManager()
    @ObservedObject var viewModel: AppViewModel
    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var scoreIncrementTime = Int.random(in: 6...7) // New variable for random score increment time
    @State private var gameTimer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var gameTimerCancellable: Cancellable?
    @State private var showCorrectMessage = false // For displaying "Correct!" feedback

    var body: some View {
        ZStack { // Overlay text directly on the camera view
            CameraPreview(session: cameraManager.session ?? AVCaptureSession())
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer().frame(height: 50) // Adjust the height here to move the overlay up

                // Align "Letter" and "Time"
                HStack {
                    Text("Letter: \(cameraManager.currentLetter)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("Time: \(timeRemaining)s") // This will align with the "Letter" text
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)

                Spacer().frame(height: 10) // Additional spacer to further adjust layout

                // Score at the top center
                Text("Score: \(score)")
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .position(x: UIScreen.main.bounds.width / 2, y: 25) // Adjust position to be at the top center
                
                Spacer()
            }

            if showCorrectMessage {
                Text("Correct!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .transition(.opacity)
                    .fontWeight(.bold)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            }
        }
        .onReceive(gameTimer) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else if self.score >= 5 {
                // Update the viewModel.score with the final score before navigation
                viewModel.score = self.score
                viewModel.currentScreen = .gestureScore
                gameTimerCancellable?.cancel() // Stop the timer to prevent further updates
            } else {
                self.showCorrectAndNextLetter()
            }

            if self.timeRemaining == scoreIncrementTime && self.score < 5 {
                self.score += 1
                self.showCorrectMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showCorrectMessage = false
                    self.nextLetter() // Reset the timer back to 10 seconds
                    self.scoreIncrementTime = Int.random(in: 6...7) // Randomize next score increment time
                }
            }
        }

        .onAppear {
            cameraManager.setupCamera()
            nextLetter()
            gameTimerCancellable = gameTimer.connect()
        }
        .onDisappear {
            cameraManager.stopCamera()
            gameTimerCancellable?.cancel()
        }
    }

    func nextLetter() {
        let letters = "ABLVWUS"
        cameraManager.currentLetter = "\(letters.randomElement()!)" // Ensure it's a letter
        timeRemaining = 10 // Resets the timer back to 10
        showCorrectMessage = false
    }
    
    func showCorrectAndNextLetter() {
        // This function now just shows the "Correct!" message and resets for the next letter
        self.showCorrectMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nextLetter()
        }
    }
}
