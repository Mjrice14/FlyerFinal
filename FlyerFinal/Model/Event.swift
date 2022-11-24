//
//  Event.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/24/22.
//

import Foundation

struct Event: Identifiable, Codable {
    var id: String
    var title: String
    var location: String
    var date: Date
    var end: Date
}
