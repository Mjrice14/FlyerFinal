//
//  FlyerFinalApp.swift
//  FlyerFinal
//
//  Created by macOS on 10/31/22.
//

import SwiftUI
import Firebase

@main
struct FlyerFinalApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
