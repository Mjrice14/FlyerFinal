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
    
    @State private var show = false
    @State private var newUserID = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("placeholder").resizable().aspectRatio(contentMode: .fit).cornerRadius(50).frame(width: 65, height: 65).padding(.trailing,7)
                VStack(alignment: .leading) {
                    Text(user.fullname).font(.title.weight(.medium))
                    Text(user.major)
                }
                Spacer()
            }.padding().frame(maxWidth: 400).background(.secondary)
                .cornerRadius(30)
        }
    }
}

struct UserBubble_Previews: PreviewProvider {
    static var previews: some View {
        UserBubble(user: User(id: "", fullname: "Matthew Rice", major: "Computer Science", tags: ["Student","Computer Science"]))
    }
}
