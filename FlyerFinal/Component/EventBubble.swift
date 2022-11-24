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
    
    let myFormat = Date.FormatStyle()
        .day()
        .month()
        .hour(.defaultDigits(amPM: .abbreviated))
        .minute(.twoDigits)
        .locale(Locale(identifier: "en_US"))
    
    
    var body: some View {
        VStack {
            HStack {
                Text(event.title+" \(event.date.formatted(myFormat))")
            }.font(.title3.weight(.medium))
        }
    }
}

struct EventBubble_Previews: PreviewProvider {
    static var previews: some View {
        EventBubble(event: Event(id: "ql0WXSB04YSsrD8bBIM3", title: "Football Game", location: "Stadium", date: Date(), end: Date()))
    }
}
