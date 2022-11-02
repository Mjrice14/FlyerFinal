//
//  DataManager.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FlyerManager: ObservableObject {
    @Published private(set) var flyers: [Flyer] = []
    let db = Firestore.firestore()
    
    init() {
        getFlyers()
    }
    
    func getFlyers() {
        db.collection("flyers").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documets: \(String(describing: error))")
                return
            }
            
            self.flyers = documents.compactMap { document -> Flyer? in
                do {
                    return try document.data(as: Flyer.self)
                } catch {
                    print("Error decoding document into Flyer: \(error)")
                    return nil
                }
                
            }
            
            self.flyers.sort { $0.date > $1.date }
        }
    }
}

class UsersManager: ObservableObject {
    @Published private(set) var users: [User] = []
    let db = Firestore.firestore()
    
    init() {
        getUsers()
    }
    
    func getUsers() {
        db.collection("users").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documets: \(String(describing: error))")
                return
            }
            
            self.users = documents.compactMap { document -> User? in
                do {
                    return try document.data(as: User.self)
                } catch {
                    print("Error decoding document into Flyer: \(error)")
                    return nil
                }
                
            }
        }
    }
}
