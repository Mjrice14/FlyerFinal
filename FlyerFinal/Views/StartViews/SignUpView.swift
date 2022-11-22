//
//  SignUpView.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct SignUpView: View {
    @Binding var signUp: Bool
    @Binding var loggedIn: Bool
    
    var majors = ["Accounting","Advertising","Agricultural","Animal Science","Anthropolgy","Architecture","Art","Biochemistry","Biology","Cell and Molecular Biology","Chemical Engineering","Chemistryy","Civil Engineering","Computer Engineering","Computer Science","Conservation Law Enforcement","Construction Engineering","Dance","Digital Media","Early Child Care","Early Childhood Education","Economics"]
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var username = ""
    @State private var major = "Accounting"
    
    @FocusState private var emailFocus: Bool
    @FocusState private var passwordFocus: Bool
    @FocusState private var fullnameFocus: Bool
    @FocusState private var majorFocus: Bool
    @FocusState private var usernameFocus: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(uiColor: .systemRed),Color(uiColor: .systemOrange)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        signUp = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .padding().font(.system(.title)).foregroundColor(.black)
                    }
                    Spacer()
                }
                Text("Sign Up").font(.system(size: 50,weight: .bold)).foregroundColor(.yellow)
                
                Spacer()
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.primary)
                        .frame(width: 38)
                    TextField("Full Name", text: $fullname)
                        .focused($fullnameFocus)
                        .foregroundColor(.primary)
                        .textFieldStyle(.plain)
                        .placeholder(when: fullname.isEmpty) {
                            Text("Full Name")
                                .foregroundColor(.primary)
                        }
                }.frame(width: 350)
                    .font(.system(size:28, weight: .medium, design: .rounded))
                    .padding(5.0)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("main")))
                
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.primary)
                        .frame(width: 38)
                    TextField("Username", text: $username)
                        .focused($usernameFocus)
                        .foregroundColor(.primary)
                        .textFieldStyle(.plain)
                        .placeholder(when: username.isEmpty) {
                            Text("Username")
                                .foregroundColor(.primary)
                        }
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                }.frame(width: 350)
                    .font(.system(size:28, weight: .medium, design: .rounded))
                    .padding(5.0)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("main")))
                
                VStack {
                    /*TextField("Major", text: $major)
                        .focused($majorFocus)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: major.isEmpty) {
                            Text("Major")
                                .foregroundColor(.white)
                        }*/
                    Text("Select your Major")
                        .foregroundColor(.primary)
                    Picker("Please choose a major", selection: $major) {
                        ForEach(majors, id: \.self) {
                            Text($0).font(.title).foregroundColor(.primary)
                        }
                    }.pickerStyle(.wheel).navigationTitle("Select your Major")
                    
                }.frame(width: 350)
                    .font(.system(size:28, weight: .medium, design: .rounded))
                    .padding(5.0)
                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color("main")))
                
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
                    TextField("Password", text: $password)
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
                    if validateFields() {
                        signUpAuth()
                    }
                } label: {
                    Text("Sign Up").font(.title).foregroundColor(.primary).padding(.horizontal).padding(.vertical,7)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color("main"))).foregroundColor(.white)
                }.padding(.top,30)
                
                Spacer()
            }
        }.toolbar {
            if signUp {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        emailFocus = false
                        passwordFocus = false
                        fullnameFocus = false
                        usernameFocus = false
                        majorFocus = false
                    }.tint(.blue)
                }
            }
        }
    }
    
    func validateFields() -> Bool {
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        fullname = fullname.trimmingCharacters(in: .whitespacesAndNewlines)
        username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (email.isEmpty || password.isEmpty || fullname.isEmpty || username.isEmpty || major.isEmpty) {
            return false
        }
        return true
    }
    
    func signUpAuth() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                let db = Firestore.firestore()
                let tag = ["Student",major]
                
                let ref = db.collection("users").document(result!.user.uid)
                ref.setData(["fullname":fullname, "username":username, "tags":tag, "major":major, "id":result!.user.uid]) { error in
                    if error != nil {
                        print("User data couldn't be saved.")
                    }
                }
                if Auth.auth().currentUser != nil {
                    Auth.auth().currentUser?.sendEmailVerification { error in
                        if error != nil {
                            print("Email failed to send.")
                        }
                    }
                }
                //uploadPhoto(login: result!.user.uid)
                loggedIn = true
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(signUp: .constant(true),loggedIn: .constant(true))
    }
}
