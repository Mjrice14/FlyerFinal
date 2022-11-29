//
//  FlyerBubble.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct FlyerBubble: View {
    var flyer: Flyer
    var display: Bool
    
    
    @State private var show = false
    @State private var newUserID = Auth.auth().currentUser?.uid
    
    @State private var postImage = UIImage(named: "placeholder2")
    
    var body: some View {
        VStack {
            let regularPost = Date.FormatStyle()
                .month()
                .day()
                .year()
                .locale(Locale(identifier: "en_US"))
            
            let samePostDay = Date.FormatStyle()
                .month()
                .day()
                .year()
                .hour(.defaultDigits(amPM: .abbreviated))
                .minute(.twoDigits)
                .locale(Locale(identifier: "en_US"))
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(flyer.name)
                            .bold()
                        if isSameDay(date1: flyer.date) {
                            Text("\(flyer.date.formatted(samePostDay))")
                        }
                        else {
                            Text("\(flyer.date.formatted(regularPost))")
                        }
                    }.foregroundColor(.black)
                    Spacer()
                }.frame(maxWidth: 350)
            }
            
            if postImage != nil {
                Image(uiImage: postImage!).resizable().aspectRatio(contentMode: .fit).frame(width: 350, height: 350)
            }
            else {
                Image("placeholder2").resizable().aspectRatio(contentMode: .fit).frame(width: 350, height: 350)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 20) {
                        Button {
                            if !display {
                                addLike()
                            }
                        } label: {
                            if flyer.likes.contains(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
                                (Text(Image(systemName: "heart.fill")).foregroundColor(.red)+Text(" ")+Text(String(flyer.likes.count)))
                            }
                            else {
                                (Text(Image(systemName: "heart"))+Text(" ")+Text(String(flyer.likes.count)))
                            }
                        }
                        Spacer()
                        Button {
                            if !display {
                                addSave()
                            }
                        } label: {
                            if flyer.saves.contains(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
                                (Text(Image(systemName: "bookmark.fill")).foregroundColor(.orange))
                            }
                            else {
                                (Text(Image(systemName: "bookmark")))
                            }
                        }
                    }.font(.title2).foregroundColor(.black)
                    
                    Text(flyer.title)
                        .font(.system(size: 30, weight: .bold, design: .rounded)).foregroundColor(.black)
                }
            }.frame(maxWidth: 350)
        }
        .padding().frame(maxWidth: 400).background(getGradient(a: flyer.color))
            .cornerRadius(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            retrieveFlyerPhoto(login: flyer.id)
        }
    }
    func addLike() {
        var flyerlikes = flyer.likes
        if flyerlikes.contains(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
            flyerlikes.remove(at: flyerlikes.firstIndex(of: newUserID!)!)
        }
        else {
            flyerlikes.append(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
        }
        let db = Firestore.firestore()
        db.collection("flyers").document(flyer.id).setData(["likes":flyerlikes], merge: true)
    }
    
    func addSave() {
        var flyersaves = flyer.saves
        if flyersaves.contains(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
            flyersaves.remove(at: flyersaves.firstIndex(of: newUserID!)!)
        }
        else {
            flyersaves.append(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62")
        }
        let db = Firestore.firestore()
        db.collection("flyers").document(flyer.id).setData(["saves":flyersaves], merge: true)
    }
    
    func isSameDay(date1:Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: Date())
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
    
    func retrieveFlyerPhoto(login:String) {
        let path = "flyers/\(login).jpg"
        let storageRef = Storage.storage().reference()
        
        let fileRef = storageRef.child(path)
        
        fileRef.getData(maxSize: Int64(5 * 1024 * 1024)) { data, error in
            if error == nil && data != nil {
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        postImage = image
                    }
                }
            }
        }
    }
}

struct FlyerBubble_Previews: PreviewProvider {
    static var previews: some View {
        FlyerBubble(flyer: Flyer(id: "1", title: "Testing", description: "This is a test to see if this will be a practical method to create flyer posts.", date: Date(), likes: ["AeVZPBqiPmPCXYxW4hlyDwnViWY2"], name: "Matthew Rice", userID: "AeVZPBqiPmPCXYxW4hlyDwnViWY2", color: 3, tags: ["Student"], saves:[]), display: true)
    }
}

func getGradient(a:Int) -> LinearGradient {
    if a == 1 {
        return .linearGradient(colors: [.blue, .indigo], startPoint: .leading, endPoint: .trailing)
    }
    else if a == 2 {
        return .linearGradient(colors: [getHexColor(hex: "#02aab0"), getHexColor(hex: "#00cdac")], startPoint: .leading, endPoint: .trailing)
    }
    else if a == 3 {
        return .linearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing)
    }
    else {
        return .linearGradient(colors: [getHexColor(hex: "#753a88"), getHexColor(hex: "#CC2B5E")], startPoint: .leading, endPoint: .trailing)
    }
}

func getHexColor(hex: String) -> Color {
    let r, g, b: CGFloat

    let start = hex.index(hex.startIndex, offsetBy: 1)
    let hexColor = String(hex[start...])
    
    let scanner = Scanner(string: hexColor)
    var hexNumber: UInt64 = 0

    if scanner.scanHexInt64(&hexNumber) {
        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        b = CGFloat(hexNumber & 0x0000ff) / 255
        return Color(red:r ,green:g ,blue:b)
    }
    return Color(.black)
}

