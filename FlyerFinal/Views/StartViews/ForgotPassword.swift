//
//  ForgotPassword.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/29/22.
//

import SwiftUI
import FirebaseAuth

struct ForgotPassword: View {
    @Binding var forgot: Bool
    
    @State private var email = ""
    @State private var email2 = ""
    @State private var emailSent = false
    
    @FocusState private var emailFocus: Bool
    @FocusState private var email2Focus: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(uiColor: .systemRed), Color(uiColor: .systemOrange)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack() {
                HStack {
                    Button {
                        emailFocus = false
                        forgot = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .padding().font(.system(.title)).foregroundColor(.black)
                    }
                    Spacer()
                }.padding(.bottom)
                
                Text("Forgot Password")
                    .font(.system(size: 35, weight: .medium, design: .rounded)).padding(.bottom,160)
                
                Text("Please enter your Email").font(.title2)
                Text("for a reset link.").font(.title2).padding(.bottom,40)
                
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.primary)
                        .frame(width: 35)
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
                }.frame(width: 300)
                    .font(.system(size:25, weight: .medium, design: .rounded))
                    .padding(5.0)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("main")))
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.primary)
                        .frame(width: 35)
                    TextField("Confirm Email", text: $email2)
                        .focused($email2Focus)
                        .foregroundColor(.primary)
                        .textFieldStyle(.plain)
                        .placeholder(when: email2.isEmpty) {
                            Text("Confirm Email")
                                .foregroundColor(.primary)
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                }.frame(width: 300)
                    .font(.system(size:25, weight: .medium, design: .rounded))
                    .padding(5.0)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("main")))

                Button {
                    if validateFields() {
                        sendReset()
                    }
                } label: {
                    Text("Continue").font(.title).foregroundColor(.primary).padding(.horizontal).frame(width: 150,height: 40)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color("main"))).foregroundColor(.white)
                }.padding(.top,90).padding(.bottom)
                Spacer()
            }
            if emailSent {
                sent
            }
        }.toolbar {
            if forgot {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        emailFocus = false
                        email2Focus = false
                    }.tint(.blue)
                }
            }
        }
    }
    
    var sent: some View {
        ZStack {
            LinearGradient(colors: [Color(uiColor: .systemRed),Color(uiColor: .systemOrange)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack {
                Text("Forgot Password")
                    .font(.system(size: 35, weight: .medium, design: .rounded))
                    .padding(.vertical, 160)
                VStack {
                    Text("A link has been sent to")
                    Text("(\(email))")
                    Text("to reset your password.")
                    Text("Make sure to check your spam!")
                }.font(.title3)
                
                Button {
                   forgot = false
                } label: {
                    Text("Return").font(.title).foregroundColor(.primary).padding(.horizontal).frame(width: 150,height: 40)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color("main"))).foregroundColor(.white)
                }.padding(.top,90).padding(.bottom)
                
                Spacer()
            }
        }
    }
    func validateFields() -> Bool {
        if (email == email2) && (!email.isEmpty && !email2.isEmpty) {
            return true
        }
        return false
    }
    
    func sendReset() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                emailSent = true
            }
            else {
                print("Error, no valid email.")
            }
        }
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword(forgot: .constant(true))
    }
}
