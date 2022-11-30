//
//  MainView.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct MainView: View {
    @Binding var signingOutNow: Bool
    
    @StateObject var usersManager = UsersManager()
    
    @State private var userHub = false
    @State private var newFlyer = false
    @State private var eventHub = false
    @State private var flyerHub = true
    @State private var myHub = false
    @State private var searching = false
    
    @State private var displayFlyer = ""
    @State private var clicked = ""
    
    
    @State private var userImage = UIImage(named: "placeholder")
    
    @State private var currentID = Auth.auth().currentUser?.uid
    
    var body: some View {
        
        ZStack {
            FlyerFeed(flyerHub: $flyerHub, displayFlyer: $displayFlyer, newFlyer: $newFlyer, searching: $searching)
            VStack {
                if userHub {
                    UserFeed(clicked: $clicked,newFlyer: $newFlyer, searching: $searching)
                }
            }
            VStack {
                if eventHub {
                    EventFeed()
                }
            }
            VStack {
                if newFlyer {
                    NewView(newFlyer: $newFlyer)
                        .transition(.move(edge: .trailing))
                }
            }
            VStack {
                if myHub {
                    MyAccountView(myHub: $myHub, signingOutNow: $signingOutNow, user: getUser(login: currentID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62"))
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !myHub && displayFlyer.isEmpty && clicked.isEmpty && !newFlyer && !searching {
                HStack(spacing: 20) {
                    if userHub {
                        Button {
                            flyerHub = true
                            userHub = false
                            eventHub = false
                            newFlyer = false
                            myHub = false
                        } label: {
                            Image(systemName: "newspaper.circle")
                                .foregroundColor(.primary)
                        }
                        Button {
                            flyerHub = false
                            userHub = false
                            eventHub = true
                            newFlyer = false
                            myHub = false
                        } label: {
                            Image(systemName: "calendar.circle")
                                .foregroundColor(.primary)
                        }
                        Button {
                            newFlyer = true
                        } label: {
                            Image(systemName: "plus.square")
                                .foregroundColor(.primary)
                        }
                        Image(systemName: "magnifyingglass.circle.fill")
                            .foregroundColor(.primary)
                        Button {
                            myHub = true
                        } label: {
                            Image(uiImage: userImage!).resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40).cornerRadius(25)
                        }
                    }
                    else if eventHub {
                        Button {
                            flyerHub = true
                            userHub = false
                            eventHub = false
                            newFlyer = false
                            myHub = false
                        } label: {
                            Image(systemName: "newspaper.circle")
                                .foregroundColor(.primary)
                        }
                        Image(systemName: "calendar.circle.fill")
                            .foregroundColor(.primary)
                        Button {
                            newFlyer = true
                        } label: {
                            Image(systemName: "plus.square")
                                .foregroundColor(.primary)
                        }
                        Button {
                            flyerHub = false
                            userHub = true
                            eventHub = false
                            newFlyer = false
                            myHub = false
                        } label: {
                            Image(systemName: "magnifyingglass.circle")
                                .foregroundColor(.primary)
                        }
                        Button {
                            myHub = true
                        } label: {
                            Image(uiImage: userImage!).resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40).cornerRadius(25)
                        }
                    }
                    else if flyerHub {
                        Image(systemName: "newspaper.circle.fill")
                            .foregroundColor(.primary)
                        Button {
                            flyerHub = false
                            newFlyer = false
                            userHub = false
                            eventHub = true
                            myHub = false
                        } label: {
                            Image(systemName: "calendar.circle")
                                .foregroundColor(.primary)
                        }
                        Button {
                            newFlyer = true
                        } label: {
                            Image(systemName: "plus.square")
                                .foregroundColor(.primary)
                        }
                        Button {
                            flyerHub = false
                            userHub = true
                            newFlyer = false
                            eventHub = false
                            myHub = false
                        } label: {
                            Image(systemName: "magnifyingglass.circle")
                                .foregroundColor(.primary)
                        }
                        Button {
                            myHub = true
                        } label: {
                            Image(uiImage: userImage!).resizable().aspectRatio(contentMode: .fit).frame(width: 40, height: 40).cornerRadius(25)
                        }
                    }
                }.font(.system(size: 40))
                    .padding(.horizontal,8)
                    .padding(.vertical,5)
                    .background(.ultraThickMaterial)
                    .cornerRadius(20)
            }
        }.animation(.easeIn, value: newFlyer)
            .onAppear {
                retrieveProfilePhoto(login: currentID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
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
    
    func getUser(login:String) -> User {
        for user in usersManager.users {
            if user.id == login {
                return user
            }
        }
        return User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "mistercoder", major: "Rich", tags: ["Millionare"], type: "admin", followers: [])
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(signingOutNow: .constant(false))
    }
}
