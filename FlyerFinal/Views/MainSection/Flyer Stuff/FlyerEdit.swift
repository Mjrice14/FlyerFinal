//
//  FlyerEdit.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/26/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct FlyerEdit: View {
    @State var id: String
    @State var color: String
    @State var description: String
    @State var title: String
    @State var tags: [String]
    @Binding var editing: Bool
    @Binding var flyerID: String
    @Binding var flyerImage: UIImage?
    @State var tempImage: UIImage?
    
    @State private var userNowID = Auth.auth().currentUser?.uid
    @State private var deleting = false
    @State private var camera = false
    @State private var pictureMethod = false
    @State private var picturePicker = false
    
    @FocusState var titleFocus: Bool
    @FocusState var descFocus: Bool
    
    @StateObject var usersManager = UsersManager()
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            let userNow = getUser(login: userNowID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
            
            VStack {
                HStack {
                    Button {
                        if validateFields() {
                            updateInfo()
                            uploadPhoto(login: id)
                            editing = false
                        }
                    } label: {
                        Text("Update").font(.title2)
                    }
                    Spacer()
                    Text("Edit Flyer").font(.title2.weight(.medium))
                    Spacer()
                    Button {
                        deleting.toggle()
                    } label: {
                        Text("Delete").font(.title2).tint(.red)
                    }.confirmationDialog("Are you sure you want to delete this flyer?", isPresented: $deleting, titleVisibility: .visible) {
                        Button("Delete") {
                            delete()
                            deleteImage()
                            flyerID = ""
                            editing = false
                        }
                    }
                }.padding(.vertical).frame(maxWidth: 400)
                ScrollView {
                    VStack(spacing: 30) {
                        HStack {
                            Text("Title:")
                            TextField("Type Here", text: $title)
                                .focused($titleFocus)
                                .foregroundColor(.primary)
                                .textFieldStyle(.plain)
                                .placeholder(when: title.isEmpty) {
                                    Text("Type Here")
                                        .foregroundColor(.primary)
                                }.padding(5.0)
                                .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color("main")))
                        }.frame(width: 375)
                        
                        VStack {
                            HStack(alignment: .top) {
                                Text("Desc:")
                                    .offset(y: 4)
                                TextField("Type Here", text: $description, axis: .vertical)
                                    .focused($descFocus)
                                    .foregroundColor(.primary)
                                    .textFieldStyle(.plain)
                                    .placeholder(when: description.isEmpty) {
                                        Text("Type Here")
                                            .foregroundColor(.primary)
                                    }.padding(5.0)
                                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color("main")))
                                    .offset(x: -5)
                            }.frame(width: 375)
                        }
                        
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
                        VStack {
                            if tempImage != nil {
                                Button {
                                    pictureMethod = true
                                } label: {
                                    Image(uiImage: tempImage!)
                                        .resizable().aspectRatio(contentMode: .fit).frame(width: 200, height: 200)
                                }
                            }
                            else {
                                Button {
                                    pictureMethod = true
                                } label: {
                                    Image("placeholder2")
                                        .resizable().aspectRatio(contentMode: .fit).frame(width: 200, height: 200)
                                }
                            }
                            Button {
                                pictureMethod = true
                            } label: {
                                Text("Change Photo").font(.title3)
                            }
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
                            ImagePicker(selectedImage: $tempImage, isPickerShowing: $picturePicker, camera: camera)
                        }
                        
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
                    }
                }
            }
        }
    }
    func validateFields() -> Bool {
        if title.isEmpty || description.isEmpty || tags.isEmpty {
            return false
        }
        return true
    }
    
    func updateInfo() {
        let db = Firestore.firestore()
        db.collection("flyers").document(id).setData(["title":title, "description":description, "color":Int(color) ?? 1, "tags":tags], merge: true)
        flyerImage = tempImage
    }
    
    func delete() {
        let db = Firestore.firestore()
        db.collection("flyers").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            }
        }
    }
    
    func deleteImage() {
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child("flyers/\(id).jpg")
        
        photoRef.delete { error in
            if let error = error {
               print(error)
            }
        }
    }
    
    func uploadPhoto(login:String) {
        let storageRef = Storage.storage().reference()
        let imageData = tempImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "flyers/\(login).jpg"
        let fileRef = storageRef.child(path)
        
        fileRef.putData(imageData!, metadata:nil)
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

struct FlyerEdit_Previews: PreviewProvider {
    static var previews: some View {
        FlyerEdit(id: "AfsNWyjGwwPq8kYoaGOr", color: "4", description:
                    "This is to make sure that the last problem was fixed, so far all other features in it function correctly.", title: "Second Post Add", tags: ["Student"], editing: .constant(false), flyerID: .constant(""),flyerImage: .constant(UIImage(named: "placeholder2")!),tempImage: UIImage(named: "placeholder2"))
    }
}
