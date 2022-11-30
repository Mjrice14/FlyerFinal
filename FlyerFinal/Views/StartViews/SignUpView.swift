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
    
    @State private var userImage = UIImage(named: "placeholder")
    @State private var camera = false
    @State private var pictureMethod = false
    @State private var picturePicker = false
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var username = ""
    @State private var major = ""
    @State private var search = ""
    
    @State private var majorSearch = false
    
    @FocusState private var emailFocus: Bool
    @FocusState private var passwordFocus: Bool
    @FocusState private var fullnameFocus: Bool
    @FocusState private var usernameFocus: Bool
    @FocusState private var searchBar: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(uiColor: .systemRed),Color(uiColor: .systemOrange)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        emailFocus = false
                        passwordFocus = false
                        fullnameFocus = false
                        usernameFocus = false
                        searchBar = false
                        majorSearch = false
                        signUp = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .padding().font(.system(.title)).foregroundColor(.black)
                    }
                    Spacer()
                }
                Text("Sign Up").font(.system(size: 50,weight: .bold)).foregroundColor(.yellow)
                
                ZStack {
                    Button {
                        pictureMethod = true
                    } label: {
                        Image(uiImage: userImage!).resizable().aspectRatio(contentMode: .fit).frame(width: 150).cornerRadius(75).padding(.bottom)
                    }.confirmationDialog("How would you like to choose your photo?", isPresented: $pictureMethod, titleVisibility: .visible) {
                        Button("Take a Photo") {
                            camera = true
                            picturePicker = true
                        }
                        Button("Choose a Photo") {
                            camera = false
                            picturePicker = true
                        }
                    }.sheet(isPresented: $picturePicker, onDismiss: nil) {
                        ImagePicker(selectedImage: $userImage, isPickerShowing: $picturePicker, camera: camera)
                    }
                    Button {
                        pictureMethod = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 40, weight: .black)).padding(4).background(Color("background")).cornerRadius(50).offset(x:50,y:50)
                    }
                }
                
                
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
                    Button {
                        majorSearch = true
                        searchBar = true
                    } label: {
                        HStack {
                            Image(systemName: "graduationcap.fill")
                                .foregroundColor(.primary)
                                .frame(width: 38)
                            if major.isEmpty {
                                Text("Select your Major")
                            }
                            else {
                                Text(major)
                            }
                            Spacer()
                        }
                    }.font(.system(size:28, weight: .medium, design: .rounded)).foregroundColor(.primary).frame(width:350).padding(5.0)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color("main")))
                    
                }
                
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
            if majorSearch {
                majorBar
            }
        }.toolbar {
            if signUp && !searchBar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        emailFocus = false
                        passwordFocus = false
                        fullnameFocus = false
                        usernameFocus = false
                    }.tint(.blue)
                }
            }
        }
    }
    var majorBar: some View {
        ZStack {
            Color("background").ignoresSafeArea().opacity(0.9)
            VStack {
                VStack {
                    VStack {
                        Text("")
                    }
                    ScrollView {
                        if search.isEmpty {
                            ForEach(majors, id: \.self) { maj in
                                Button {
                                    major = maj
                                    searchBar = false
                                    majorSearch = false
                                } label: {
                                    if major.isEmpty {
                                        HStack {
                                            Text(maj).font(.title2).foregroundColor(.primary)
                                            Spacer()
                                        }.frame(width: 400).padding(.bottom,5)
                                    }
                                    else {
                                        HStack {
                                            if major == maj {
                                                Text(maj).font(.title2).foregroundColor(.primary)
                                                Spacer()
                                                Image(systemName: "checkmark")
                                            }
                                            else {
                                                Text(maj).font(.title2).foregroundColor(.primary)
                                                Spacer()
                                            }
                                        }.frame(width: 400).padding(.bottom,5)
                                    }
                                }
                                Divider()
                            }
                        }
                        else {
                            ForEach(majors, id: \.self) { maj in
                                if maj.lowercased().contains(search.lowercased()) {
                                    Button {
                                        major = maj
                                        searchBar = false
                                        majorSearch = false
                                    } label: {
                                        HStack {
                                            Text(maj).font(.title2).foregroundColor(.primary)
                                            Spacer()
                                        }.frame(width: 400).padding(.bottom,5)
                                    }
                                }
                            }
                        }
                    }
                }.toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass").padding(.trailing,4)
                                TextField("Search", text: $search)
                                    .focused($searchBar)
                                    .foregroundColor(.primary)
                                    .textFieldStyle(.plain)
                                    .placeholder(when: search.isEmpty) {
                                        Text("Search")
                                            .foregroundColor(.primary)
                                    }
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                if !search.isEmpty {
                                    Button {
                                        search = ""
                                    } label: {
                                        Image(systemName: "xmark").background(.ultraThinMaterial).cornerRadius(20)
                                    }.tint(.primary)
                                }
                            }.padding(5).background(.secondary)
                                .cornerRadius(20)
                                .font(.system(size: 18))
                                .frame(maxWidth: 350)
                            Spacer()
                            Button("Done") {
                                searchBar = false
                            }.tint(.blue)
                        }.frame(maxWidth: 400, maxHeight: 50)
                    }
                }
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass").padding(.trailing,4)
                        TextField("Search", text: $search)
                            .focused($searchBar)
                            .foregroundColor(.primary)
                            .textFieldStyle(.plain)
                            .placeholder(when: search.isEmpty) {
                                Text("Search")
                                    .foregroundColor(.primary)
                            }
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                        if !search.isEmpty {
                            Button {
                                search = ""
                            } label: {
                                Image(systemName: "xmark")
                                    .padding(3).background(.ultraThinMaterial).cornerRadius(20)
                            }.tint(.primary)
                        }
                    }.padding(5).background(.secondary)
                        .cornerRadius(20)
                        .font(.title3)
                        .frame(maxWidth: 350)
                    Spacer()
                    Button {
                        searchBar = false
                        majorSearch = false
                    } label: {
                        Text("Done")
                    }
                }.frame(width: 400).font(.title3).padding(.bottom,8)
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
                
//                let ref = db.collection("users").document(result!.user.uid)
//                ref.setData(["fullname":fullname, "username":username, "tags":tag, "major":major, "id":result!.user.uid,"followers":[],"type":"student"]) { error in
//                    if error != nil {
//                        print("User data couldn't be saved.")
//                    }
//                }
                if Auth.auth().currentUser != nil {
                    Auth.auth().currentUser?.sendEmailVerification { error in
                        if error != nil {
                            print("Email failed to send.")
                        }
                    }
                }
                uploadPhoto(login: result!.user.uid)
                loggedIn = true
            }
        }
    }
    
    func uploadPhoto(login:String) {
        let storageRef = Storage.storage().reference()
        let imageData = userImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "users/\(login).jpg"
        let fileRef = storageRef.child(path)
        
        fileRef.putData(imageData!, metadata:nil)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(signUp: .constant(true),loggedIn: .constant(true))
    }
}
