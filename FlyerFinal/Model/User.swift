//
//  User.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var fullname: String
    var major: String
    var tags: [String]
}
