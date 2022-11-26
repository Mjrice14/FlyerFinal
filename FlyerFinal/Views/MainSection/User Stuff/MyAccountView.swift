//
//  MyAccountView.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/25/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct MyAccountView: View {
    @Binding var myHub: Bool
    @Binding var signingOutNow: Bool
    var user: User
    
    @StateObject var flyerManager = FlyerManager()
    @StateObject var usersManager = UsersManager()
    
    @State private var currentID = Auth.auth().currentUser?.uid
    @State private var displayFlyer = ""
    
    @State private var userImage = UIImage(named: "placeholder")
    
    @State private var signingOut = false
    @State private var showEdit = false
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Button {
                        myHub = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(.title)).foregroundColor(.primary)
                    }.frame(maxWidth: 300).padding(.trailing,50)
                    Text(user.username)
                        .font(.title2.weight(.medium)).frame(maxWidth: 300)
                    Button {
                        signingOut = true
                    } label: {
                        Text("Sign Out")
                            .font(.title2)
                    }.frame(maxWidth: 300).confirmationDialog("Are you sure you would like to log out of your account?", isPresented: $signingOut, titleVisibility: .visible) {
                        Button("Sign Out") {
                            signOutUser()
                            signingOutNow = true
                        }
                    }
                }.padding(.top,5)
                ScrollView {
                    HStack {
                        if userImage != nil {
                            Image(uiImage: userImage!).resizable().aspectRatio(contentMode: .fit).cornerRadius(50).frame(width: 100, height: 100).padding(.leading,30)                        }
                        else {
                            Image("placeholder").resizable().aspectRatio(contentMode: .fit).cornerRadius(50).frame(width: 100, height: 100).padding(.leading,30)
                        }
                        Spacer()
                        HStack {
                            VStack {
                                Text(String(getPost(login: user.id))).fontWeight(.bold)
                                Text("Posts")
                            }
                            Spacer()
                            VStack {
                                Text(String(getLikes(login: user.id))).fontWeight(.bold)
                                Text("Likes")
                            }
                        }.frame(maxWidth: 100).padding(.trailing,40)
                    }
                    HStack{
                        Text(user.fullname).font(.title2.weight(.medium)).padding(.leading,30)
                        Spacer()
                    }
                    HStack {
                        Text(user.major).font(.title3).padding(.leading,30)
                        Spacer()
                    }
                    Button {
                        showEdit = true
                    } label: {
                        Text("Edit Profile").foregroundColor(.primary)
                            .padding(.vertical,6).frame(maxWidth: 400).background(.tertiary).cornerRadius(10).padding(.bottom,8)
                    }.tint(.primary)
                    ForEach(flyerManager.flyers,id: \.id) {flyer in
                        if flyer.userID == user.id {
                            FlyerBubble(flyer: flyer, display: false).onTapGesture{
                                displayFlyer = flyer.id
                            }
                        }
                    }
                }
            }
            if showEdit {
                UserEditView(showEdit: $showEdit, user: user)
                    .transition(.move(edge: .bottom))
            }
            if !displayFlyer.isEmpty {
                FlyerView(flyer: getFlyer(flyerId: displayFlyer), flyerID: $displayFlyer)
            }
        }.animation(.easeIn, value: showEdit).onAppear {
            retrieveProfilePhoto(login: currentID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
        }
    }
    
    func getLikes(login:String) -> Int {
        var count = 0
        for flyer in flyerManager.flyers {
            if flyer.userID == login {
                count = count + flyer.likes.count
            }
        }
        return count
    }
    
    func getPost(login:String) -> Int {
        var count = 0
        for flyer in flyerManager.flyers {
            if flyer.userID == login {
                count = count + 1
            }
        }
        return count
    }
    
    func retrieveProfilePhoto(login:String) {
        let path = "users/\(login).jpg"
        let storageRef = Storage.storage().reference()
        
        let fileRef = storageRef.child(path)
        
        fileRef.getData(maxSize: Int64(5 * 1024 * 1024)) { data, error in
            if error == nil && data != nil {
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        userImage = image
                    }
                }
            }
        }
    }
    
    func signOutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func getFlyer(flyerId:String) -> Flyer {
        for flyer in flyerManager.flyers {
            if flyer.id == flyerId {
                return flyer
            }
        }
        return Flyer(id: "AfsNWyjGwwPq8kYoaGOr", title: "Testing", description: "This is a test to see if this will be a practical method to create flyer posts.", date: Date(), imageName: "image.yuj", likes: ["fRIWBPjsqlbFxVjb5ylH5PMVun62"], name: "Matthew Rice", userID: "fRIWBPjsqlbFxVjb5ylH5PMVun62", color: 3, tags: ["Student"])
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView(myHub: .constant(true), signingOutNow: .constant(false), user: User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Matthew Rice", username: "mistercoder", major: "Rich", tags: ["Millionare"], type: "admin"))
    }
}
