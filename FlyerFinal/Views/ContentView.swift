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
    
    @State private var signingOutNow = false
    
    var body: some View {
        ZStack {
//            if Auth.auth().currentUser != nil && !signingOutNow {
//                if Auth.auth().currentUser!.isEmailVerified {
//                    MainView(signingOutNow: $signingOutNow)
//                }
//                else {
//                    StartPageView(authentic: $authentic, loggedIn: .constant(true))
//                }
//            }
            if !authentic || signingOutNow {
                StartPageView(authentic: $authentic, loggedIn: $loggedIn, signingOutNow: $signingOutNow)
            }
            else {
                MainView(signingOutNow: $signingOutNow)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
