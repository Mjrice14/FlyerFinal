//
//  SettingsMenu.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 12/5/22.
//

import SwiftUI
import FirebaseAuth

struct SettingsMenu: View {
    @Binding var settings: Bool
    @Binding var admin: Bool
    @Binding var darkMode: Bool
    
    @StateObject var usersManager = UsersManager()
    
    @State private var newUserID = Auth.auth().currentUser?.uid
    
    var body: some View {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        ZStack {
            let userNow = getUser(login: newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
            HStack {
                VStack {
                    Color("main").ignoresSafeArea().frame(width: screenWidth/1.25)
                }
                Spacer()
            }
            HStack {
                VStack {
                    HStack {
                        Text("Settings").font(.title2.weight(.medium)).padding(.leading)
                        Spacer()
                        Button {
                            settings = false
                        } label: {
                            Text("Close").font(.title2.weight(.medium)).padding(.trailing)
                        }
                    }.padding(.top)
                    Divider()
                    if userNow.type.lowercased() == "admin" {
                        Toggle(isOn: $admin) {
                            Text("Admin Mode")
                        }.font(.title3.weight(.regular))
                            .padding(.trailing).frame(width: (screenWidth/1.25)-30)
                        Divider().frame(width: (screenWidth/1.25)-30)
                    }
                    Toggle(isOn: $darkMode) {
                        Text("Dark Mode")
                    }.font(.title3.weight(.regular))
                        .padding(.trailing).frame(width: (screenWidth/1.25)-30)
                    Spacer()
                }.frame(width: screenWidth/1.25)
                Spacer()
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
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu(settings: .constant(true), admin: .constant(false), darkMode: .constant(false))
    }
}
