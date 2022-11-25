//
//  UserBubble.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/22/22.
//

import SwiftUI
import FirebaseAuth

struct UserBubble: View {
    var user: User
    @Binding var clicked: String
    
    @State private var show = false
    @State private var newUserID = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("placeholder").resizable().aspectRatio(contentMode: .fit).cornerRadius(50).frame(width: 55, height: 55).padding(.trailing,7)
                VStack(alignment: .leading) {
                    Text(user.fullname).font(.title2.weight(.bold))
                    Text(user.username).font(.title3.weight(.medium))
                }
                Spacer()
            }.padding(6).frame(maxWidth: 400).background(.secondary)
                .cornerRadius(30)
        }.padding(.bottom,5)
    }
}

struct UserBubble_Previews: PreviewProvider {
    static var previews: some View {
        UserBubble(user: User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Matthew Rice", username: "misterkiller", major: "Computer Science", tags: ["Student","Computer Science"], type: "admin"), clicked: .constant(""))
    }
}
