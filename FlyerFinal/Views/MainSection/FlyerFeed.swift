//
//  FlyerFeed.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct FlyerFeed: View {    
    @Binding var flyerHub: Bool
    @Binding var displayFlyer: String
    @Binding var newFlyer: Bool
    @Binding var searching: Bool
    @Binding var darkMode: Bool
    
    @StateObject var flyerManager = FlyerManager()
    @StateObject var usersManager = UsersManager()
    
    @State private var newUserID = Auth.auth().currentUser?.uid
    @State private var filter = "Public"
    @State private var bookmark = false
    @State private var editingPost = false
    @State private var refresh = false
    
    @State private var flyerImage = UIImage(named: "placeholder2")
    
    @State private var search = ""
    @State private var bar = false
    @State private var settings = false
    @State private var admin = false
    
    @FocusState private var searchFocus: Bool
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            let userNow = getUser(login: newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
            VStack {
                HStack {
                    Button {
                        settings.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .padding(.leading).font(.title2.weight(.medium))
                            .foregroundColor(.primary)
                    }
                    Text("Recent Flyer Feed").font(.title2.weight(.medium))
                    
                    Spacer()
                    
                    Button {
                        bar.toggle()
                        searchFocus.toggle()
                        searching.toggle()
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
                        if admin {
                            Button {
                                filter = "All"
                            } label: {
                                if filter == "All" {
                                    HStack{
                                        Text("All")
                                        Image(systemName: "checkmark")
                                    }
                                }
                                else {
                                    Text("All")
                                }
                            }
                        }
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
                
                Divider()
                
                ScrollView {
                    ForEach(flyerManager.flyers,id: \.id) {flyer in
                        if filter == "All" {
                            if refresh {
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
                            else {
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
                        if flyer.tags.contains(filter) {
                            if refresh {
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
                            else {
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
                
            }
                .refreshable {
                refresh.toggle()
            }
            if !displayFlyer.isEmpty {
                FlyerView(flyer: getFlyer(flyerId: displayFlyer), flyerID: $displayFlyer, editing: $editingPost)
            }
            if settings {
                SettingsMenu(settings: $settings, admin: $admin, darkMode: $darkMode)
                    .transition(.move(edge: .leading))
            }
       }.animation(.easeIn, value: settings)
            .onChange(of: admin) { newState in
                if newState == false {
                    filter = "Public"
                }
                else {
                    filter = "All"
                }
                
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
    
    func getFlyer(flyerId:String) -> Flyer {
        for flyer in flyerManager.flyers {
            if flyer.id == flyerId {
                return flyer
            }
        }
        return Flyer(id: "AfsNWyjGwwPq8kYoaGOr", title: "Testing", description: "This is a test to see if this will be a practical method to create flyer posts.", date: Date(), likes: ["fRIWBPjsqlbFxVjb5ylH5PMVun62"], name: "Matthew Rice", userID: "fRIWBPjsqlbFxVjb5ylH5PMVun62", color: 3, tags: ["Student"], saves:[])
    }
}

struct FlyerFeed_Previews: PreviewProvider {
    static var previews: some View {
        FlyerFeed(flyerHub: .constant(true),displayFlyer: .constant(""), newFlyer: .constant(true), searching: .constant(false), darkMode: .constant(false))
    }
}
