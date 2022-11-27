//
//  Flyer.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import Foundation

struct Flyer: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var date: Date
    var imageName: String
    var likes: [String]
    var name: String
    var userID: String
    var color: Int
    var tags: [String]
    var saves: [String]
}
