//
//  EventBubble.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/24/22.
//

import SwiftUI
import FirebaseAuth

struct EventBubble: View {
    var event:Event
    
    let myMonth = Date.FormatStyle()
        .month()
        .locale(Locale(identifier: "en_US"))
    
    let myDay = Date.FormatStyle()
        .day()
        .locale(Locale(identifier: "en_US"))
    
    let myTime = Date.FormatStyle()
        .hour(.defaultDigits(amPM: .abbreviated))
        .minute(.twoDigits)
        .locale(Locale(identifier: "en_US"))
    
    
    var body: some View {
        VStack {
//            HStack {
//                Text(event.title+" \(event.date.formatted(myFormat))")
//            }.font(.title3.weight(.medium))
            HStack {
                VStack(spacing: -6) {
                    Text(event.date.formatted(myDay))
                        .font(.title.weight(.black))
                    Text(event.date.formatted(myMonth))
                        .font(.title2.weight(.medium))
                }
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.title2.weight(.bold))
                    Text(event.date.formatted(myTime)+", "+event.location)
                        .font(.title3)
                }.padding(.leading,8)
            }
        }
    }
}

struct EventBubble_Previews: PreviewProvider {
    static var previews: some View {
        EventBubble(event: Event(id: "ql0WXSB04YSsrD8bBIM3", title: "Football Game", location: "Stadium", date: Date(), end: Date()))
    }
}
