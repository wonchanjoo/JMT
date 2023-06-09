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
    func saveUser(user: User) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
        db.collection("User").document(user.nickname).setData(["data": data as Any])
    }
    
    func validUser(nickname: String, password: String, completion: @escaping (Bool) -> Void) {
        let ref = db.collection("User").document(nickname)
        ref.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataRef = document.data()?["data"]
                if let data = dataRef {
                    let user = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as! Data) as? User
                    if(password == user?.password) {
                        completion(true)
                    } else { // 비밀번호가 틀린 경우
                        completion(false)
                    }
                }
            } else { // 계정이 존재하지 않는 경우
                completion(false)
            }
        }
    }
    
    // user에 group_code field 존재 여부
    func haveGroupCode(nickname: String, completion: @escaping (Bool) -> Void) {
        let ref = db.collection("User").document(nickname)
        ref.getDocument{ (document, error) in
            if let groupCode = document?.data()?["group_code"] as? String {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

// 그룹
extension Database {
    func saveGroupCode(code: String, name: String) {
        db.collection("Group").document(code).setData(["name": name])
    }
    
}

// 가게
