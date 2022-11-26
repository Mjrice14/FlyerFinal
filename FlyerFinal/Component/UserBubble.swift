//
//  UserBubble.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/22/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct UserBubble: View {
    var user: User
    @Binding var clicked: String
    
    @State private var show = false
    @State private var newUserID = Auth.auth().currentUser?.uid
    
    @State private var userImage = UIImage(named: "placeholder")
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if userImage != nil {
                    Image(uiImage: userImage!).resizable().aspectRatio(contentMode: .fit).cornerRadius(50).frame(width: 55, height: 55).padding(.trailing,7)
                }
                else {
                    Image("placeholder").resizable().aspectRatio(contentMode: .fit).cornerRadius(50).frame(width: 55, height: 55).padding(.trailing,7)
                }
                VStack(alignment: .leading) {
                    Text(user.fullname).font(.title2.weight(.bold))
                    Text(user.username).font(.title3.weight(.medium))
                }
                Spacer()
            }.padding(6).frame(maxWidth: 400).background(.secondary)
                .cornerRadius(30)
        }.padding(.bottom,5)
            .onAppear {
                retrieveProfilePhoto(login: user.id)
            }
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
}

struct UserBubble_Previews: PreviewProvider {
    static var previews: some View {
        UserBubble(user: User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Matthew Rice", username: "mistercoder", major: "Computer Science", tags: ["Student","Computer Science"], type: "admin"), clicked: .constant(""))
    }
}
