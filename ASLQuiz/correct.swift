//
//  correct.swift
//  ASLQuiz
//
//  Created by Carson Lee on 2024-03-11.
//

import Foundation
import AVFoundation
import SwiftUI

struct GestureRecognitionGameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var cameraManager: CameraManager
    @ObservedObject var viewModel: AppViewModel
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    @State private var currentLetter = ""
    @State private var timeRemaining = 10
    @State private var timer: Timer?

    func startGame() {
        pickRandomLetter()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                endGame(success: false)
            }
        }
    }

    func pickRandomLetter() {
        currentLetter = String(letters.randomElement()!)
        timeRemaining = 10 // Reset timer for the new letter
    }

    func endGame(success: Bool) {
        timer?.invalidate()
        timer = nil
        if success {
            viewModel.score += 1
            pickRandomLetter() // Start again with a new letter
            startGame()
        } else {
            viewModel.currentScreen = .gestureScore // Redirect to GestureScoreView
        }
    }

    var body: some View {
        ZStack {
            if let session = cameraManager.session {
                CameraPreview(session: session)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Loading")
                    .foregroundColor(.green)
            }
            
            if cameraManager.isCameraRunning { // Only display when the camera is running
                VStack(spacing: 20) { // Adjusted spacing for visual clarity
                    Text("Perform the ASL gesture for: \(currentLetter)")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Time: \(timeRemaining)s")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // Move Score text here, under the "Perform the ASL gesture for:" text
                    Text("Score: \(viewModel.score)")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.top, 50) // Adjust this padding as needed to position the VStack appropriately on the screen
            } else {
                Text("Loading")
                    .foregroundColor(.green)
            }
        }
        .onAppear {
            print("Attempting to setup camera...")
            cameraManager.setupCamera()
            startGame()
            print("Camera setup should be complete.")
        }
        .onDisappear {
            cameraManager.stopCamera()
        }
    }
}
