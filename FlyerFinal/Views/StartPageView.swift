//
//  StartPageView.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI

struct StartPageView: View {
    @Binding var authentic: Bool
    @Binding var loggedIn: Bool
    
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
        }.animation(.easeIn, value: signUp)
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView(authentic: .constant(false), loggedIn: .constant(false))
    }
}
