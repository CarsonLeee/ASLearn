//
//  ASLQuizApp.swift
//  ASLQuizC
//
//  Created by Carson Lee on 2024-02-23.
//

import SwiftUI
import Firebase

@main
struct ASLQuizApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
