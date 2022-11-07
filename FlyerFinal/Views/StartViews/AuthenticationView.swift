//
//  AuthenticationView.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI
import FirebaseAuth

struct AuthenticationView: View {
    @Binding var authentic: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(uiColor: .systemRed),Color(uiColor: .systemOrange)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            //if Auth.auth().currentUser != nil {
            VStack {
                let email = Auth.auth().currentUser?.email ?? "test@ttu.edu"
                let displayEmail = "("+email+")"
                Image("flyerSocial").resizable().aspectRatio(contentMode: .fit).frame(width: 350,height: 350)
                VStack {
                    Text("Please check your email")
                    Text(displayEmail)
                    Text("For a link to verify your")
                    Text("Email address.")
                    Text("")
                    Text("(The email may show")
                    Text("up in your spam folder.)")
                }
                Button {
                    if Auth.auth().currentUser != nil {
                        if Auth.auth().currentUser!.isEmailVerified {
                            authentic = true
                        }
                    }
                    authentic = true
                    
                } label: {
                    Text("Email Verified").font(.title).padding(.horizontal).frame(width: 300).padding(.vertical,5)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color(red: 0.22, green: 0.22, blue: 0.22))).foregroundColor(.white)
                }.padding(.top, 70)
                
                Button {
                    if Auth.auth().currentUser != nil {
                        if Auth.auth().currentUser!.isEmailVerified {
                            Auth.auth().currentUser?.sendEmailVerification { error in
                                if error != nil {
                                    print("Email failed to send.")
                                }
                            }
                        }
                    }
                    
                } label: {
                    Text("Resend Email").font(.title).padding(.horizontal).frame(width: 300).padding(.vertical,5)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color(red: 0.22, green: 0.22, blue: 0.22))).foregroundColor(.white)
                }.padding()
                
            }
            //}
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(authentic: .constant(false))
    }
}
