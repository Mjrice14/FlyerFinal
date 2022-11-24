//
//  User.swift
//  FlyerFinal
//
//  Created by matt on 11/1/22.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var fullname: String
    var username: String
    var major: String
    var tags: [String]
    var type: String
}
