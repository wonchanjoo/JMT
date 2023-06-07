//
//  Database.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/07.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class Database {
    let db = Firestore.firestore()
}

// user
extension Database {
    func saveUser(key: String, user: User) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
        db.collection("User").document(key).setData(["data": data as Any])
    }
}

// 그룹
extension Database {
    func saveGroupCode(code: String, name: String) {
        db.collection("Group").document(code).setData(["name": name])
    }
}

// 가게
