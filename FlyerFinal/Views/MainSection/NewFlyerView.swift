//
//  NewFlyerView.swift
//  FlyerFinal
//
//  Created by macOS on 11/2/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct NewFlyerView: View {
    @Binding var newFlyer: Bool
    @Binding var viewType: String
    
    @StateObject var usersManager = UsersManager()
    
    @State private var newUserID = Auth.auth().currentUser?.uid
    @State private var color = "4"
    @State private var title = ""
    @State private var description = ""
    @State private var tags = ["Public"]
    
    @FocusState private var tiltleFocus: Bool
    @FocusState private var descFocus: Bool
    
    var body: some View {
        ZStack {
            let userNow = getUser(login: newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
            
            Color("main").ignoresSafeArea()
            
//            Button {
//                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                    newFlyer = false
//                }
//            } label: {
//                Image(systemName: "xmark")
//                    .font(.body.weight(.bold))
//                    .foregroundColor(.secondary)
//                    .padding(8)
//                    .background(.ultraThinMaterial, in: Circle())
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//            .padding(20)
//            .padding(.top, 25)
//            .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Text("New Flyer")
                        .foregroundColor(.primary).font(.title2).padding([.leading,.top])
                    Spacer()
                }
                //if userNow.tags.contains("Staff") {
                    Picker(selection: $viewType, label: Text("New Type")) {
                        Text("Flyer").tag("flyer")
                        Text("Event").tag("event")
                    }.pickerStyle(SegmentedPickerStyle()).frame(maxWidth: 400).padding(.bottom,5)
                //}
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 15) {
                        FlyerBubble(flyer: Flyer(id: "", title: "Example Post", description: "This is an example of how your post would look.", date: Date(), imageName: "", likes: [], name: userNow.fullname, userID: userNow.id, color: Int(color)!, tags: ["Public"]),display: true)
                            .padding(.bottom,20)
                        
                        TextField("Title", text: $title)
                            .focused($tiltleFocus)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: title.isEmpty) {
                                Text("Title")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 350)
                            .padding(5.0)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(red: 0.22, green: 0.22, blue: 0.22)))
                        
                        
                        TextField("Description", text: $description, axis: .vertical)
                            .focused($descFocus)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: description.isEmpty) {
                                Text("Description")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 350)
                            .padding(5.0)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(red: 0.22, green: 0.22, blue: 0.22)))
                        
                        Picker(selection: $color) {
                            Text("Blue").tag("1")
                            Text("Green").tag("2")
                            Text("Orange").tag("3")
                            Text("Purple").tag("4")
                        } label: {
                            Text("Color Picker")
                        }.pickerStyle(MenuPickerStyle())
                            .padding([.leading,.trailing,])
                            .tint(.white)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(red: 0.22, green: 0.22, blue: 0.22)))
                        
                        Menu {
                            Button {
                                if tags.contains("Public") {
                                    tags.remove(at: (tags.firstIndex(of: "Public")!))
                                }
                                else {
                                    tags.append("Public")
                                }
                            } label: {
                                if tags.contains("Public") {
                                    HStack {
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
                                    if tags.contains(tag) {
                                        tags.remove(at: (tags.firstIndex(of: tag)!))
                                    }
                                    else {
                                        tags.append(tag)
                                    }
                                } label: {
                                    if tags.contains(tag) {
                                        HStack {
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
                            Text("TAGS")
                                .font(.system(size: 30))
                            
                        }.padding([.leading,.trailing],35.0).padding([.top,.bottom])
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(red: 0.22, green: 0.22, blue: 0.22))).foregroundColor(.white)
                            .frame(height: 25)
                            .frame(maxHeight: 25)
                            .padding(.vertical)
                    }
                }
                Button {
                    newFlyerCreate()
                    newFlyer = false
                } label: {
                    Text("Submit").font(.title).foregroundColor(.primary).padding(.horizontal).frame(width: 150,height: 40)
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color("main")))
                }
            }
        }.toolbar {
            if newFlyer {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        tiltleFocus = false
                        descFocus = false
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
        return User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "misterkiller", major: "Rich", tags: ["Millionare"], type: "admin")
    }
    
    func validateFields() -> Bool {
        if title.isEmpty || description.isEmpty {
            return false
        }
        return true
    }
    
    func newFlyerCreate() {
        let db = Firestore.firestore()
        let userNow = getUser(login: newUserID ?? "j4vd5j1O3tcCaH7oDifrb7GMHe62")
        let docID = randomString(length: 20)

        let docref = db.collection("flyers").document(docID)
            docref.setData(["color":Int(color) ?? 1, "date":Date(), "description":description, "imageName":"none","likes":[] ,"name":userNow.fullname, "title":title, "id":(docID) ,"userID":newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62","tags":tags]) { error in
                if error != nil {
                    print("Flyer data could not be uploaded!")
                }
            }
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

struct NewFlyerView_Previews: PreviewProvider {
    static var previews: some View {
        NewFlyerView(newFlyer: .constant(true), viewType: .constant("flyer"))
    }
}
