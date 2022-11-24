//
//  UserFeed.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI

struct UserFeed: View {
    @StateObject var flyerManager = FlyerManager()
    @StateObject var usersManager = UsersManager()
    @State private var clicked = ""
    
    @State var search = ""
    
    @FocusState private var searchFocus: Bool
    var body: some View {
        if clicked.isEmpty {
            content
        }
        else {
            UserAccount(user: getUser(login: clicked), clicked: $clicked)
        }
    }
    
    var content: some View {
        ZStack {
            Color("main").ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("User Serach").font(.title2.weight(.medium)).padding(.leading)
                    Spacer()
                    HStack {
                        Image(systemName: "magnifyingglass").padding(.leading,7)
                        TextField("Serach", text: $search)
                            .focused($searchFocus)
                            .foregroundColor(.primary)
                            .textFieldStyle(.plain)
                            .placeholder(when: search.isEmpty) {
                                Text("Search")
                                    .foregroundColor(.primary)
                            }
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                    }.frame(maxWidth: 120)
                        .padding(.trailing).padding(.vertical,8).background(.secondary)
                        .cornerRadius(20)
                }.padding([.top,.trailing])
                ScrollView {
                    ForEach(usersManager.users,id: \.id) {user in
                        if search.isEmpty {
                            UserBubble(user: user, clicked: $clicked).tint(.primary).onTapGesture {
                                clicked = user.id
                            }
                        }
                        else {
                            if user.fullname.lowercased().contains(search.lowercased()) || user.username.lowercased().contains(search.lowercased()) {
                                Button {
                                    clicked = user.id
                                } label: {
                                    UserBubble(user: user, clicked: $clicked).tint(.primary)
                                }
                            }
                        }
                    }
                }
            }
        }.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    searchFocus = false
                }.tint(.blue)
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

struct UserFeed_Previews: PreviewProvider {
    static var previews: some View {
        UserFeed()
    }
}
