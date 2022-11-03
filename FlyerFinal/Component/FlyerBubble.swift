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
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(flyer.name)
                                .bold()
                            Text("\(flyer.date.formatted())")
                        }
                    }
                    
                    Text(flyer.title)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .padding(.bottom, 5.0)
                        
                    
                    Text(flyer.description)
                        .fontWeight(.medium)
                    
                    HStack(spacing: 20) {
                        Button {
                            if !display {
                                addLike()
                            }
                        } label: {
                            if flyer.likes.contains(newUserID ?? "fRIWBPjsqlbFxVjb5ylH5PMVun62") {
                                (Text(Image(systemName: "heart.fill"))+Text(" ")+Text(String(flyer.likes.count)))
                                    .font(.system(size: 20))
                            }
                            else {
                                (Text(Image(systemName: "heart"))+Text(" ")+Text(String(flyer.likes.count)))
                                    .font(.system(size: 20))
                            }
                        }.foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.top)
                }
            }.padding().frame(maxWidth: 400).background(getGradient(a: flyer.color))
                .cornerRadius(30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
}

struct FlyerBubble_Previews: PreviewProvider {
    static var previews: some View {
        FlyerBubble(flyer: Flyer(id: "1", title: "Testing", description: "This is a test to see if this will be a practical method to create flyer posts.", date: Date(), imageName: "image.yuj", likes: ["AeVZPBqiPmPCXYxW4hlyDwnViWY2"], name: "Matthew Rice", userID: "AeVZPBqiPmPCXYxW4hlyDwnViWY2", color: 2, tags: ["Student"]), display: true)
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
        return .linearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
    }
    else {
        return .linearGradient(colors: [getHexColor(hex: "#CC2B5E"), getHexColor(hex: "#753a88")], startPoint: .leading, endPoint: .trailing)
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

