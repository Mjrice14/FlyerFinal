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
    
    @State var search = ""
    
    @FocusState private var searchFocus: Bool
    var body: some View {
        ZStack {
            //Color.primary.ignoresSafeArea()
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
                        .cornerRadius(10)
                }.padding([.top,.trailing])
                ScrollView {
                    ForEach(usersManager.users,id: \.id) {user in
                        if search.isEmpty {
                            UserBubble(user: user)
                        }
                        else {
                            if user.fullname.lowercased().contains(search.lowercased()) {
                                UserBubble(user: user)
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
}

struct UserFeed_Previews: PreviewProvider {
    static var previews: some View {
        UserFeed()
    }
}
