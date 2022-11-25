//
//  ContentView.swift
//  FlyerFinal
//
//  Created by macOS on 10/31/22.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var authentic = false
    @State private var loggedIn = false
    
    var body: some View {
        ZStack {
            if Auth.auth().currentUser != nil {
                if Auth.auth().currentUser!.isEmailVerified {
                    MainView()
                }
                else {
                    StartPageView(authentic: $authentic, loggedIn: .constant(true))
                }
            }
            else if !authentic {
                StartPageView(authentic: $authentic, loggedIn: $loggedIn)
            }
            else {
                MainView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
