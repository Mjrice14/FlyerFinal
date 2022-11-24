//
//  FlyerFeed.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FlyerFeed: View {    
    @StateObject var flyerManager = FlyerManager()
    @StateObject var usersManager = UsersManager()
    
    @State private var newUserID = Auth.auth().currentUser?.uid
    @State private var filter = "Public"
    
    var body: some View {
        ZStack {
            Color("main").ignoresSafeArea()
            
            let userNow = getUser(login: newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
            
            VStack {
                HStack {
                    Text("Recent Flyer Feed").font(.title2.weight(.medium))
                        .padding([.leading,.top])
                    Spacer()
                    
                    Menu {
                        Button {
                            filter = "Public"
                        } label: {
                            if filter == "Public" {
                                HStack{
                                    Text("Public")
                                    Image(systemName: "checkmark")
                                }
                            }
                            else {
                                Text("Public")
                            }
                        }
                        ForEach(userNow.tags, id: \.self) { tag in
                            Button {
                                filter = tag
                            } label: {
                                if filter == tag {
                                    HStack{
                                        Text(tag)
                                        Image(systemName: "checkmark")
                                    }
                                }
                                else {
                                    Text(tag)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }.font(.title2.weight(.medium)).padding(.trailing).foregroundColor(.primary)
                }
                
                ScrollView {
                    ForEach(flyerManager.flyers,id: \.id) {flyer in
                        if flyer.tags.contains(filter) {
                            FlyerBubble(flyer: flyer, display: false)
                        }
                    }
                }
            }
        }
    }
    
    func getUser(login:String) -> User {
        for user in usersManager.users {
            if user.id == login {
                return user
            }
        }
        return User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "misterkiller", major: "Rich", tags: ["Millionare"], type: "admin")
    }
}

struct FlyerFeed_Previews: PreviewProvider {
    static var previews: some View {
        FlyerFeed()
    }
}
