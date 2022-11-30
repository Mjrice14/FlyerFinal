//
//  LoginView.swift
//  FlyerFinal
//
//  Created by macOS on 10/31/22.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var signUp: Bool
    @Binding var loggedIn: Bool
    @Binding var authentic: Bool
    
    @State private var password = ""
    @State private var email = ""
    
    @FocusState private var passwordFocus: Bool
    @FocusState private var emailFocus: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(uiColor: .systemRed),Color(uiColor: .systemOrange)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack {
                Image("flyerSocial").resizable().aspectRatio(contentMode: .fit).frame(width: 400, height: 400)
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.primary)
                        .frame(width: 38)
                    TextField("Email", text: $email)
                        .focused($emailFocus)
                        .foregroundColor(.primary)
                        .textFieldStyle(.plain)
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                                .foregroundColor(.primary)
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                }.frame(width: 350)
                    .font(.system(size:28, weight: .medium, design: .rounded))
                    .padding(5.0)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("main")))
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.primary)
                        .frame(width: 38)
                    SecureField("Password", text: $password)
                        .focused($passwordFocus)
                        .foregroundColor(.primary)
                        .textFieldStyle(.plain)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.primary)
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                }.frame(width: 350)
                    .font(.system(size:28, weight: .medium, design: .rounded))
                    .padding(5.0)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("main")))
                Button {
                    login()
                } label: {
                    Text("Login").font(.title).foregroundColor(.primary).padding(.horizontal).frame(width: 150,height: 40)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color("main"))).foregroundColor(.white)
                }.padding(.top,30).padding(.bottom)
                
                Button {
                    emailFocus = false
                    passwordFocus = false
                    signUp = true
                } label: {
                    Text("Need an account? Sign Up").foregroundColor(.primary)
                }            
            }
        }.toolbar {
            if !signUp {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        emailFocus = false
                        passwordFocus = false
                    }.tint(.blue)
                }
            }
        }
    }
    func login() {
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                if Auth.auth().currentUser!.isEmailVerified {
                    authentic = true
                }
                else {
                    Auth.auth().currentUser?.sendEmailVerification { error in
                        if error != nil {
                            print("Error sending an email verification.")
                        }
                    }
                    authentic = false
                }
                loggedIn = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(signUp: .constant(false), loggedIn: .constant(false), authentic: .constant(false))
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
