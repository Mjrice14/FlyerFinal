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
    @Binding var flyerHub: Bool
    @Binding var displayFlyer: String
    @Binding var newFlyer: Bool
    
    @StateObject var flyerManager = FlyerManager()
    @StateObject var usersManager = UsersManager()
    
    @State private var newUserID = Auth.auth().currentUser?.uid
    @State private var filter = "Public"
    @State private var bookmark = false
    @State private var editingPost = false
    
    
    @State private var search = ""
    @State private var bar = false
    
    @FocusState private var searchFocus: Bool
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            let userNow = getUser(login: newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
            
            VStack {
                HStack {
                    Text("Recent Flyer Feed").font(.title2.weight(.medium))
                        .padding(.leading)
                    Spacer()
                    
                    Button {
                        bar.toggle()
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
                    
                    Button {
                        bookmark.toggle()
                    } label: {
                        if !bookmark {
                            Image(systemName: "bookmark")
                                .font(.title3)
                        }
                        else {
                            Image(systemName: "bookmark.fill").foregroundColor(.orange)
                                .font(.title3)
                        }
                    }.tint(.primary)
                    
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
                    }.font(.title2.weight(.medium)).foregroundColor(.primary)
                }.padding([.top,.trailing])
                
                if bar {
                    HStack {
                        Image(systemName: "magnifyingglass").padding(.trailing,4)
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
                    }.padding(5).background(.secondary)
                        .cornerRadius(20)
                        .font(.title3)
                        .frame(maxWidth: 400)
                }
                
                Divider()
                
                ScrollView {
                    ForEach(flyerManager.flyers,id: \.id) {flyer in
                        if flyer.tags.contains(filter) {
                            if bookmark {
                                if flyer.saves.contains(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
                                    if search.isEmpty {
                                        FlyerBubble(flyer: flyer, display: false).padding(.bottom,5).onTapGesture {
                                            displayFlyer = flyer.id
                                        }
                                    }
                                    else if flyer.title.lowercased().contains(search.lowercased()) {
                                        FlyerBubble(flyer: flyer, display: false).padding(.bottom,5).onTapGesture {
                                            displayFlyer = flyer.id
                                        }
                                    }
                                    else if flyer.name.lowercased().contains(search.lowercased()) {
                                        FlyerBubble(flyer: flyer, display: false).padding(.bottom,5).onTapGesture {
                                            displayFlyer = flyer.id
                                        }
                                    }
                                }
                            }
                            else {
                                if search.isEmpty {
                                    FlyerBubble(flyer: flyer, display: false).padding(.bottom,5).onTapGesture {
                                        displayFlyer = flyer.id
                                    }
                                }
                                else if flyer.title.lowercased().contains(search.lowercased()) {
                                    FlyerBubble(flyer: flyer, display: false).padding(.bottom,5).onTapGesture {
                                        displayFlyer = flyer.id
                                    }
                                }
                                else if flyer.name.lowercased().contains(search.lowercased()) {
                                    FlyerBubble(flyer: flyer, display: false).padding(.bottom,5).onTapGesture {
                                        displayFlyer = flyer.id
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if !displayFlyer.isEmpty {
                FlyerView(flyer: getFlyer(flyerId: displayFlyer), flyerID: $displayFlyer, editing: $editingPost)
            }
       }.toolbar {
           if flyerHub && !newFlyer && !editingPost {
               ToolbarItemGroup(placement: .keyboard) {
                   Spacer()
                   Button("Done") {
                       searchFocus = false
                   }.tint(.blue)
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
        return User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "misterkiller", major: "Rich", tags: ["Millionare"], type: "admin", followers: [])
    }
    
    func getFlyer(flyerId:String) -> Flyer {
        for flyer in flyerManager.flyers {
            if flyer.id == flyerId {
                return flyer
            }
        }
        return Flyer(id: "AfsNWyjGwwPq8kYoaGOr", title: "Testing", description: "This is a test to see if this will be a practical method to create flyer posts.", date: Date(), imageName: "image.yuj", likes: ["fRIWBPjsqlbFxVjb5ylH5PMVun62"], name: "Matthew Rice", userID: "fRIWBPjsqlbFxVjb5ylH5PMVun62", color: 3, tags: ["Student"], saves:[])
    }
}

struct FlyerFeed_Previews: PreviewProvider {
    static var previews: some View {
        FlyerFeed(flyerHub: .constant(true),displayFlyer: .constant(""), newFlyer: .constant(true))
    }
}
