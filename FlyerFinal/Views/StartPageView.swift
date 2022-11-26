//
//  StartPageView.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI
import FirebaseAuth

struct StartPageView: View {
    @Binding var authentic: Bool
    @Binding var loggedIn: Bool
    @Binding var signingOutNow: Bool
    
    @State private var signUp = false
    
    var body: some View {
        ZStack {
            if !loggedIn {
                LoginView(signUp: $signUp, loggedIn: $loggedIn, authentic: $authentic)
                
                VStack {
                    if signUp {
                        SignUpView(signUp: $signUp, loggedIn: $loggedIn)
                            .transition(.move(edge: .trailing))
                    }
                }
            }
            else {
                if !authentic {
                    AuthenticationView(authentic: $authentic)
                }
            }
        }.animation(.easeIn, value: signUp).onAppear {
            if Auth.auth().currentUser != nil {
                loggedIn = true
                if Auth.auth().currentUser!.isEmailVerified {
                    authentic = true
                }
            }
            else {
                signingOutNow = false
                loggedIn = false
                authentic = false
            }
        }
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView(authentic: .constant(false), loggedIn: .constant(false), signingOutNow: .constant(false))
    }
}
