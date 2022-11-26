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
    var flyer:Flyer
    
    @StateObject var usersManager = UsersManager()
    
    @State private var userNowID = Auth.auth().currentUser?.uid
    @State private var userImage = UIImage(named: "placeholder")
    
    var body: some View {
        ZStack {
            getGradient(a: flyer.color).ignoresSafeArea()
            
            let userNow = getUser(login: userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
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
                Text(flyer.title).font(.title.weight(.medium))
                
                ScrollView {
                    Image("placeholder2").resizable().aspectRatio(contentMode: .fit).frame(width: 400, height: 400)
                    HStack {
                        Button {
                            addLike()
                        } label: {
                            if flyer.likes.contains(userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
                                (Text(Image(systemName: "heart.fill")).foregroundColor(.red)+Text(" ")+Text(String(flyer.likes.count)))
                                    .font(.system(size: 20))
                            }
                            else {
                                (Text(Image(systemName: "heart"))+Text(" ")+Text(String(flyer.likes.count)))
                                    .font(.system(size: 20))
                            }
                        }.foregroundColor(.primary)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.arrow.down").font(.system(size: 20)).foregroundColor(.primary)
                        }
                    }.frame(maxWidth: 400)
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
                            }
                        }
                        Spacer()
                    }.frame(maxWidth: 400)
                    Text(flyer.description).frame(maxWidth: 400)
                    HStack {
                        VStack {
                            if isSameDay(date1: flyer.date) {
                                Text(flyer.date.formatted(samePostDay))
                            }
                            else {
                                Text(flyer.date.formatted(regularPost))
                            }
                        }.foregroundColor(.secondary).fontWeight(.medium)
                        Spacer()
                    }.frame(maxWidth: 395)
                }
            }
        }.preferredColorScheme(.light)
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
        return User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "mistercoder", major: "Rich", tags: ["Millionare"], type: "admin")
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
}

extension UIView {
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct FlyerView_Previews: PreviewProvider {
    static var previews: some View {
        FlyerView(flyer: Flyer(id: "1", title: "Testing", description: "This is a test to see if this will be a practical method to create flyer posts.", date: Date(), imageName: "image.yuj", likes: ["AeVZPBqiPmPCXYxW4hlyDwnViWY2"], name: "Matthew Rice", userID: "AeVZPBqiPmPCXYxW4hlyDwnViWY2", color: 3, tags: ["Student"]))
    }
}

