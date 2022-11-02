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
            if !authentic {
                StartPageView(authentic: $authentic,loggedIn: $loggedIn)
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
