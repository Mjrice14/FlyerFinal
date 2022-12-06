//
//  UserEditView.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/25/22.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

struct UserEditView: View {
    @Binding var showEdit: Bool
    var user: User
    @Binding var signingOutNow: Bool
    
    @State private var userImage = UIImage(named: "placeholder")
    @State private var camera = false
    @State private var pictureMethod = false
    @State private var picturePicker = false
    @State private var deleting = false
    @State private var confirmation = false
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        showEdit = false
                    } label: {
                        Text("Cancel")
                    }.tint(.primary)
                    Spacer()
                    Text("Edit profile").fontWeight(.medium)
                        .offset(x: -5)
                    Spacer()
                    Button {
                        uploadPhoto(login: user.id)
                        showEdit = false
                    } label: {
                        Text("Done").fontWeight(.medium)
                    }
                }.frame(maxWidth: 400).font(.title2).padding(.top)
                
                Divider()
                
                ScrollView {
                    VStack {
                        if userImage != nil {
                            Button {
                                pictureMethod = true
                            } label: {
                                Image(uiImage: userImage!).resizable().aspectRatio(contentMode: .fit).cornerRadius(75).frame(width: 150, height: 150)
                            }
                        }
                        else {
                            Button {
                                pictureMethod = true
                            } label: {
                                Image("placeholder").resizable().aspectRatio(contentMode: .fit).cornerRadius(75).frame(width: 150, height: 150)
                            }
                        }
                        Button {
                            pictureMethod = true
                        } label: {
                            Text("Edit Photo").font(.title3)
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
                        ImagePicker(selectedImage: $userImage, isPickerShowing: $picturePicker, camera: camera)
                    }
                }
                Button {
                    deleting = true
                } label: {
                    Text("Delete Account").font(.title.weight(.medium)).tint(.red)
                }.alert("Are you suere you want to delete your account?", isPresented: $deleting) {
                    Button("Delete") {
                        confirmation = true
                    }
                    Button("Cancel") {
                        deleting = false
                    }
                }.alert("This is your last chance, your account will be permenantly deleted.", isPresented: $confirmation) {
                    Button("Delete") {
                        //delete()
                        signOutUser()
                        signingOutNow = true
                    }
                    Button("Cancel") {
                        confirmation = false
                    }
                }
            }
        }.onAppear {
            retrieveProfilePhoto(login: user.id)
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
    
    func uploadPhoto(login:String) {
        let storageRef = Storage.storage().reference()
        let imageData = userImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        let path = "users/\(login).jpg"
        let fileRef = storageRef.child(path)
        
        fileRef.putData(imageData!, metadata:nil)
    }
    
    func delete() {
        let user = Auth.auth().currentUser
        
        // Remove Firestore User
        let db = Firestore.firestore()
        db.collection("users").document(user!.uid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            }
        }
        
        // Remove User Photo
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child("users/\(user!.uid).jpg")
        
        photoRef.delete { error in
            if let error = error {
               print(error)
            }
        }

        
        // Remove Auth User
        user?.delete { error in
            if let error = error {
                print("An Errror has occured, \(error)")
            }
        }
    }
    func signOutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct UserEditView_Previews: PreviewProvider {
    static var previews: some View {
        UserEditView(showEdit: .constant(true), user: User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "mistercoder", major: "Rich", tags: ["Millionare"], type: "admin", followers: []), signingOutNow: .constant(false))
    }
}
