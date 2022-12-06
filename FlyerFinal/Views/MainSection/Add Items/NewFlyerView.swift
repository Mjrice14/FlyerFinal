//
//  NewFlyerView.swift
//  FlyerFinal
//
//  Created by macOS on 11/2/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct NewFlyerView: View {
    @Binding var newFlyer: Bool
    @Binding var viewType: String
    
    @StateObject var usersManager = UsersManager()
    
    @State private var flyerImage = UIImage(named: "placeholder2")
    @State private var newUserID = Auth.auth().currentUser?.uid
    @State private var color = "4"
    @State private var title = ""
    @State private var description = ""
    @State private var tags = ["Public"]
    
    @State private var camera = false
    @State private var pictureMethod = false
    @State private var picturePicker = false
    
    @FocusState private var tiltleFocus: Bool
    @FocusState private var descFocus: Bool
    
    var body: some View {
        ZStack {
            let userNow = getUser(login: newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
            
            Color("background").ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Text("New Flyer")
                        .foregroundColor(.primary).font(.title2).padding(.leading)
                    Spacer()
                    Button {
                        newFlyer = false
                    } label: {
                        Text("Cancel")
                            .font(.title2).padding(.trailing)
                    }
                }.padding(.top)
                if userNow.type.lowercased() == "admin" || userNow.type.lowercased() == "staff" {
                    Picker(selection: $viewType, label: Text("New Type")) {
                        Text("Flyer").tag("flyer")
                        Text("Event").tag("event")
                    }.pickerStyle(SegmentedPickerStyle()).frame(maxWidth: 400).padding(.bottom,5)
                }
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        if flyerImage != nil {
                            Button {
                                pictureMethod = true
                            } label: {
                                Image(uiImage: flyerImage!).resizable().aspectRatio(contentMode: .fit).frame(width: 200)
                            }
                        }
                        else {
                            Button {
                                pictureMethod = true
                            } label: {
                                Image("placeholder2").resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 200)
                            }
                        }
                        
                        Button {
                            pictureMethod = true
                        } label: {
                            Text("Select Photo").font(.title3.weight(.medium))
                        }.confirmationDialog("How would you like to choose your photo?", isPresented: $pictureMethod, titleVisibility: .visible) {
                            Button("Take a Photo") {
                                camera = true
                                picturePicker = true
                            }
                            Button("Choose a Photo") {
                                camera = false
                                picturePicker = true
                            }
                        }.sheet(isPresented: $picturePicker, onDismiss: nil) {
                            ImagePicker(selectedImage: $flyerImage, isPickerShowing: $picturePicker, camera: camera)
                        }
                        
                        TextField("Title", text: $title)
                            .focused($tiltleFocus)
                            .foregroundColor(.primary)
                            .textFieldStyle(.plain)
                            .placeholder(when: title.isEmpty) {
                                Text("Title")
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 350)
                            .padding(5.0)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color("main")))
                        
                        
                        TextField("Description", text: $description, axis: .vertical)
                            .focused($descFocus)
                            .foregroundColor(.primary)
                            .textFieldStyle(.plain)
                            .placeholder(when: description.isEmpty) {
                                Text("Description")
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 350)
                            .padding(5.0)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color("main")))
                        
                        Text("").frame(width: 75, height: 75).background(getGradient(a: Int(color)!))
                        
                        Picker(selection: $color) {
                            Text("Blue").tag("1")
                            Text("Green").tag("2")
                            Text("Orange").tag("3")
                            Text("Purple").tag("4")
                        } label: {
                            Text("Color Picker")
                        }.pickerStyle(MenuPickerStyle())
                            .padding([.leading,.trailing,])
                            .tint(.primary)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color("main")))
                        
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
                                .fill(Color("main"))).foregroundColor(.primary)
                            .frame(height: 25)
                            .frame(maxHeight: 25)
                            .padding(.vertical)
                        
                        Button {
                            if validateFields() {
                                newFlyerCreate()
                                newFlyer = false
                            }
                        } label: {
                            Text("Submit").font(.title).foregroundColor(.primary).padding(.horizontal).frame(width: 150,height: 40)
                                .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color("main")))
                        }
                    }
                }
            }
        }.toolbar {
            if newFlyer && viewType == "flyer" {
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
        return User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "misterkiller", major: "Rich", tags: ["Millionare"], type: "admin", followers: [])
    }
    
    func validateFields() -> Bool {
        if title.isEmpty || description.isEmpty || tags.isEmpty {
            return false
        }
        return true
    }
    
    func newFlyerCreate() {
        let db = Firestore.firestore()
        let userNow = getUser(login: newUserID ?? "j4vd5j1O3tcCaH7oDifrb7GMHe62")
        let docID = randomString(length: 20)

        let docref = db.collection("flyers").document(docID)
        docref.setData(["color":Int(color) ?? 1, "date":Date(), "description":description,"likes":[] ,"name":userNow.fullname, "title":title, "id":(docID) ,"userID":newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62","tags":tags, "saves":[]]) { error in
                if error != nil {
                    print("Flyer data could not be uploaded!")
                }
            }
        uploadPhoto(login: docID)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func uploadPhoto(login:String) {
        let storageRef = Storage.storage().reference()
        let imageData = flyerImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "flyers/\(login).jpg"
        let fileRef = storageRef.child(path)
        
        fileRef.putData(imageData!, metadata:nil)
    }
}

struct NewFlyerView_Previews: PreviewProvider {
    static var previews: some View {
        NewFlyerView(newFlyer: .constant(true), viewType: .constant("flyer"))
    }
}
