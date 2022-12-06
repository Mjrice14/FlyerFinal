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
    @Binding var clicked: String
    @Binding var newFlyer: Bool
    @Binding var searching: Bool
    @Binding var darkMode: Bool
    
    @State private var search = ""
    @State private var bar = false
    @State private var settings = false
    @State private var admin = false
    
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
            Color("background").ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        settings.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .padding(.leading).font(.title2.weight(.medium))
                            .foregroundColor(.primary)
                    }
                    Text("User Serach").font(.title2.weight(.medium))
                    Spacer()
                    Button {
                        bar.toggle()
                        searching.toggle()
                        searchFocus.toggle()
                    } label: {
                        if !bar {
                            Image(systemName: "magnifyingglass")
                                .font(.title3)
                        }
                        else {
                            Text("Close")
                                .font(.title3)
                        }
                    }.tint(.primary)
                }.padding([.top,.trailing])
                
                Divider()
                
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
                
                if bar {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass").padding(.trailing,4)
                            TextField("Search", text: $search)
                                .focused($searchFocus)
                                .foregroundColor(.primary)
                                .textFieldStyle(.plain)
                                .placeholder(when: search.isEmpty) {
                                    Text("Search")
                                        .foregroundColor(.primary)
                                }
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                            if !search.isEmpty {
                                Button {
                                    search = ""
                                } label: {
                                    Image(systemName: "xmark")
                                        .padding(3).background(.ultraThinMaterial).cornerRadius(20)
                                }.tint(.primary)
                            }
                        }.padding(5).background(.secondary)
                            .cornerRadius(20)
                            .font(.title3)
                            .frame(maxWidth: 350)
                        Spacer()
                        Button {
                            searchFocus = false
                            searching = false
                            bar = false
                        } label: {
                            Text("Done")
                        }
                    }.frame(width: 400).font(.title3).padding(.bottom,8)
                }
            }.animation(.easeIn, value: settings)
            if settings {
                SettingsMenu(settings: $settings, admin: $admin, darkMode: $darkMode)
                    .transition(.move(edge: .leading))
            }
        }
        
    }
    func getUser(login:String) -> User {
        for user in usersManager.users {
            if user.id == login {
                return user
            }
        }
        return User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "misterkiller", major: "Rich", tags: ["Millionare"], type: "admin", followers: [])
    }
}

struct UserFeed_Previews: PreviewProvider {
    static var previews: some View {
        UserFeed(clicked: .constant(""), newFlyer: .constant(true), searching: .constant(false), darkMode: .constant(false))
    }
}
