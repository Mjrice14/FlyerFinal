//
//  FlyerView.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/26/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct FlyerView: View {
    var flyer: Flyer
    @Binding var flyerID: String
    @Binding var editing: Bool
    
    @StateObject var usersManager = UsersManager()
    
    @State private var userNowID = Auth.auth().currentUser?.uid
    @State private var userImage = UIImage(named: "placeholder")
    @State private var flyerImage = UIImage(named: "placeholder2")
    @State private var screenshot = false
    @State private var show = true
    
    @FocusState private var titleFocus: Bool
    @FocusState private var descFocus: Bool
    
    var body: some View {
        ZStack {
            getGradient(a: flyer.color).ignoresSafeArea()
            
            
            
//            let userNow = getUser(login: userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
            let userCreate = getUser(login: flyer.userID)
            
            let regularPost = Date.FormatStyle()
                .month()
                .day()
                .year()
                .locale(Locale(identifier: "en_US"))
            
            let samePostDay = Date.FormatStyle()
                .month()
                .day()
                .year()
                .hour(.defaultDigits(amPM: .abbreviated))
                .minute(.twoDigits)
                .locale(Locale(identifier: "en_US"))
            
            VStack {
                VStack {
                    if show {
                        HStack {
                            Button {
                                flyerID = ""
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            Spacer()
                            Button {
                                screenshot = true
                            } label: {
                                Image(systemName: "square.and.arrow.down")
                            }
                        }
                    }
                }.frame(maxWidth: 400).font(.title2.weight(.medium)).foregroundColor(.black)
                    .confirmationDialog("This will show a view to screenshot this flyer, you will have 10 seconds to take the screenshot.", isPresented: $screenshot, titleVisibility: .visible) {
                        Button("Continue") {
                            show.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                show.toggle()
                            }
                        }
                    }
                
                Text(flyer.title).font(.title.weight(.medium)).foregroundColor(.black)
                
                ScrollView {
                    if flyerImage != nil {
                        Image(uiImage: flyerImage!)
                            .resizable().aspectRatio(contentMode: .fit).frame(width: 400, height: 400)
                    }
                    else {
                        Image("placeholder2")
                            .resizable().aspectRatio(contentMode: .fit).frame(width: 400, height: 400)
                    }
                    HStack {
                        Button {
                            addLike()
                        } label: {
                            if flyer.likes.contains(userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
                                (Text(Image(systemName: "heart.fill")).foregroundColor(.red)+Text(" ")+Text(String(flyer.likes.count)))
                            }
                            else {
                                (Text(Image(systemName: "heart"))+Text(" ")+Text(String(flyer.likes.count)))
                            }
                        }
                        Spacer()
                        
                        if flyer.userID == userNowID {
                            Button {
                                editing = true
                            } label: {
                                Text("Edit")
                            }.padding(.trailing).foregroundColor(.blue)
                        }
                        
                        
                        Button {
                            addSave()
                        } label: {
                            if flyer.saves.contains(userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
                                (Text(Image(systemName: "bookmark.fill")).foregroundColor(.orange))
                            }
                            else {
                                (Text(Image(systemName: "bookmark")))
                            }
                        }
                    }.frame(maxWidth: 400).font(.title2).foregroundColor(.black)
                        .sheet(isPresented: $editing) {
                            FlyerEdit(id: flyer.id, color: String(flyer.color), description: flyer.description, title: flyer.title, tags: flyer.tags, editing: $editing, flyerID: $flyerID, flyerImage: $flyerImage, tempImage: flyerImage, titleFocus: _titleFocus, descFocus: _descFocus)
                        }
                    VStack {
                        HStack {
                            HStack {
                                if userImage != nil {
                                    Image(uiImage: userImage!).resizable().aspectRatio(contentMode: .fit).cornerRadius(50).frame(width: 50, height: 50)
                                }
                                else {
                                    Image("placeholder").resizable().aspectRatio(contentMode: .fit).cornerRadius(50).frame(width: 50, height: 50)
                                }
                                VStack(alignment: .leading) {
                                    Text(flyer.name).font(.title2.weight(.medium))
                                    Text(userCreate.username)
                                }.foregroundColor(.black)
                            }
                            Spacer()
                        }.frame(maxWidth: 400)
                        HStack {
                            Text(flyer.description).foregroundColor(.black)
                            Spacer()
                        }.frame(maxWidth: 400)
                        HStack {
                            VStack {
                                if isSameDay(date1: flyer.date) {
                                    Text(flyer.date.formatted(samePostDay))
                                }
                                else {
                                    Text(flyer.date.formatted(regularPost))
                                }
                            }.foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41)).fontWeight(.medium)
                            Spacer()
                        }.frame(maxWidth: 400)
                    }
                }
            }
        }.onAppear {
            retrieveProfilePhoto(login: flyer.userID)
            retrieveFlyerPhoto(login: flyer.id)
        }.refreshable {
            retrieveProfilePhoto(login: flyer.userID)
            retrieveFlyerPhoto(login: flyer.id)
        }.toolbar {
            if editing {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        titleFocus = false
                        descFocus = false
                    }.tint(.blue)
                }
            }
         }
    }
    
    
    func isSameDay(date1:Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: Date())
        if diff.day == 0 {
            return true
        } else {
            return false
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
    
    func addLike() {
        var flyerlikes = flyer.likes
        if flyerlikes.contains(userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
            flyerlikes.remove(at: flyerlikes.firstIndex(of: userNowID!)!)
        }
        else {
            flyerlikes.append(userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
        }
        let db = Firestore.firestore()
        db.collection("flyers").document(flyer.id).setData(["likes":flyerlikes], merge: true)
    }
    
    func addSave() {
        var flyersaves = flyer.saves
        if flyersaves.contains(userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
            flyersaves.remove(at: flyersaves.firstIndex(of: userNowID!)!)
        }
        else {
            flyersaves.append(userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
        }
        let db = Firestore.firestore()
        db.collection("flyers").document(flyer.id).setData(["saves":flyersaves], merge: true)
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
    
    func retrieveFlyerPhoto(login:String) {
        let path = "flyers/\(login).jpg"
        let storageRef = Storage.storage().reference()
        
        let fileRef = storageRef.child(path)
        
        fileRef.getData(maxSize: Int64(5 * 1024 * 1024)) { data, error in
            if error == nil && data != nil {
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        flyerImage = image
                    }
                }
            }
        }
    }
}

struct FlyerView_Previews: PreviewProvider {
    static var previews: some View {
        FlyerView(flyer: Flyer(id: "AfsNWyjGwwPq8kYoaGOr", title: "Testing", description: "This is a test to see if this will be a practical method to create flyer posts.", date: Date(), likes: ["fRIWBPjsqlbFxVjb5ylH5PMVun62"], name: "Matthew Rice", userID: "fRIWBPjsqlbFxVjb5ylH5PMVun62", color: 3, tags: ["Student"], saves:[]),flyerID: .constant(""), editing: .constant(false))
    }
}


