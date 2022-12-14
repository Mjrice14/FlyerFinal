//
//  UserAccount.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/23/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct UserAccount: View {
    var user: User
    @Binding var clicked: String
    
    @StateObject var flyerManager = FlyerManager()
    @StateObject var usersManager = UsersManager()
    
    @State private var userImage = UIImage(named: "placeholder")
    @State private var displayFlyer = ""
    @State private var editingPost = false
    
    @State private var newUserID = Auth.auth().currentUser?.uid
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            let userNow = getUser(login: newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
            
            VStack {
                
                HStack {
                    Button {
                        clicked = ""
                    } label: {
                        Image(systemName: "chevron.left")
                            .padding(.leading).font(.system(.title)).foregroundColor(.primary)
                    }
                    
                    Spacer()
                    Text(user.username).font(.title2.weight(.medium))
                        .padding(.trailing,30)
                    Spacer()
                }.padding(.top)
                ScrollView {
                    HStack {
                        if userImage != nil {
                            Image(uiImage: userImage!).resizable().aspectRatio(contentMode: .fit).cornerRadius(50).frame(width: 100, height: 100).padding(.leading,30)
                        }
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
                            Spacer()
                            VStack {
                                Text("\(user.followers.count)").fontWeight(.bold)
                                Text("Followers")
                            }
                        }.frame(maxWidth: 190).padding(.trailing,40)
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
                        addFollower()
                    } label: {
                        if user.followers.contains(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
                            Text("Following User").foregroundColor(.primary)
                                .padding(.vertical,6).frame(maxWidth: 400).background(Color("main")).cornerRadius(10).padding(.bottom,8)
                        }
                        else {
                            Text("Follow User").foregroundColor(.primary)
                                .padding(.vertical,6).frame(maxWidth: 400).background(Color("main")).cornerRadius(10).padding(.bottom,8)
                        }
                    }.tint(.primary)
                    ForEach(flyerManager.flyers,id: \.id) {flyer in
                        if flyer.userID == user.id {
                            if canView(user: userNow, flyer: flyer) {
                                FlyerBubble(flyer: flyer, display: false, admin: false).onTapGesture {
                                    displayFlyer = flyer.id
                                }
                            }
                        }
                    }
                }
            }
            if !displayFlyer.isEmpty {
                FlyerView(flyer: getFlyer(flyerId: displayFlyer), flyerID: $displayFlyer, editing: $editingPost)
            }
        }
        .onAppear {
            retrieveProfilePhoto(login: user.id)
        }
    }
    func getUser(login:String) -> User {
        for user in usersManager.users {
            if user.id == login {
                return user
            }
        }
        return User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "mistercoder", major: "Rich", tags: ["Millionare"], type: "admin", followers: [])
    }
    
    func addFollower() {
        var userfollowers = user.followers
        if userfollowers.contains(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
            userfollowers.remove(at: userfollowers.firstIndex(of: newUserID!)!)
        }
        else {
            userfollowers.append(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
        }
        let db = Firestore.firestore()
        db.collection("users").document(user.id).setData(["followers":userfollowers], merge: true)
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
    
    func canView(user:User,flyer:Flyer) -> Bool {
        for tag in flyer.tags {
            if user.tags.contains(tag) {
                return true
            }
        }
        return false
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
    
    func getFlyer(flyerId:String) -> Flyer {
        for flyer in flyerManager.flyers {
            if flyer.id == flyerId {
                return flyer
            }
        }
        return Flyer(id: "AfsNWyjGwwPq8kYoaGOr", title: "Testing", description: "This is a test to see if this will be a practical method to create flyer posts.", date: Date(), likes: ["fRIWBPjsqlbFxVjb5ylH5PMVun62"], name: "Matthew Rice", userID: "fRIWBPjsqlbFxVjb5ylH5PMVun62", color: 3, tags: ["Student"], saves:[])
    }
}

struct UserAccount_Previews: PreviewProvider {
    static var previews: some View {
        UserAccount(user: User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Matthew Rice", username: "misterkiller", major: "Computer Science", tags: ["Student","Computer Science"], type: "admin", followers: []), clicked: .constant(""))
    }
}
