//
//  NewEventView.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/25/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewEventView: View {
    @Binding var newFlyer: Bool
    @Binding var viewType: String
    
    @StateObject var usersManager = UsersManager()
    
    @State private var title = ""
    @State private var location = ""
    @State private var start = Date()
    @State private var end = Date()
    
    @State private var newUserID = Auth.auth().currentUser?.uid
    
    @FocusState private var tiltleFocus: Bool
    @FocusState private var locationFocus: Bool
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("New Event")
                        .foregroundColor(.primary).font(.title2).padding(.leading)
                    Spacer()
                    Button {
                        newFlyer = false
                    } label: {
                        Text("Cancel")
                            .font(.title2).padding(.trailing)
                    }
                }.padding(.top)
                Picker(selection: $viewType, label: Text("New Type")) {
                    Text("Flyer").tag("flyer")
                    Text("Event").tag("event")
                }.pickerStyle(SegmentedPickerStyle()).frame(maxWidth: 400).padding(.bottom,5)
                
                Divider()
                
                ScrollView {
                    
                    VStack(spacing: 30) {
                        TextField("Title", text: $title)
                            .focused($tiltleFocus)
                            .foregroundColor(.primary)
                            .textFieldStyle(.plain)
                            .placeholder(when: title.isEmpty) {
                                Text("Title")
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 375)
                            .padding(5.0)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color("main")))
                        
                        TextField("Location", text: $location)
                            .focused($locationFocus)
                            .foregroundColor(.primary)
                            .textFieldStyle(.plain)
                            .placeholder(when: location.isEmpty) {
                                Text("Location")
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 375)
                            .padding(5.0)
                            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color("main")))
                        
                        DatePicker(selection: $start, label: { Text("Start Date") }).frame(maxWidth: 375)
                        DatePicker(selection: $end, label: { Text("End Date") }).frame(maxWidth: 375)
                        
                        Button {
                            if validateFields() {
                                newEventCreate()
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
            if newFlyer && viewType == "event" {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        tiltleFocus = false
                        locationFocus = false
                    }.tint(.blue)
                }
            }
        }
    }
    func newEventCreate() {
        let db = Firestore.firestore()
//        let userNow = getUser(login: newUserID ?? "j4vd5j1O3tcCaH7oDifrb7GMHe62")
        let docID = randomString(length: 20)

        let docref = db.collection("events").document(docID)
        docref.setData(["date":start, "end":end, "id":docID, "location":location, "title":title]) { error in
                if error != nil {
                    print("Event data could not be uploaded!")
                }
            }
    }
    
    func validateFields() -> Bool {
        if title.isEmpty || location.isEmpty {
            return false
        }
        return true
    }
    
    func getUser(login:String) -> User {
        for user in usersManager.users {
            if user.id == login {
                return user
            }
        }
        return User(id: "fRIWBPjsqlbFxVjb5ylH5PMVun62", fullname: "Elon Musk", username: "misterkiller", major: "Rich", tags: ["Millionare"], type: "admin", followers: [])
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(newFlyer: .constant(true), viewType: .constant("event"))
    }
}
