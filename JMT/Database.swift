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
            if document?.data()?["group_code"] is String {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getGroupCode(nickname: String, completion: @escaping (String) -> Void) {
        let ref = db.collection("User").document(nickname)
        ref.getDocument{ (document, error) in
            if let groupCode = document?.data()?["group_code"] {
                completion(groupCode as! String)
            } else {
                completion("")
            }
        }
    }
}

// 그룹
extension Database {
    func saveGroupCode(code: String, name: String) {
        db.collection("Group").document(code).setData(["name": name])
    }
    
    func addGroupUser(code: String, nickname: String) {
        db.collection("User").document(nickname).updateData(["group_code": code])
        db.collection("Group").document(code).getDocument { (document, error) in
            if let document = document, document.exists {
                var users = document.data()?["users"] as? [String] ?? []
                users.append(nickname) // add new user
                self.db.collection("Group").document(code).updateData(["users": users]) // DB에 저장
            }
        }
    }
    
    func getGroupList(completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        db.collection("Group").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("getGroupList error: \(error.localizedDescription)")
                completion(nil, error)
            } else {
                guard let groupList = querySnapshot?.documents else {
                    print("GroupList가 존재하지 않습니다.")
                    completion(nil, nil)
                    return
                }
                completion(groupList, nil)
            }
        }
    }
}

// 가게
extension Database {
    func saveStore(groupCode: String, item: Item) {
        var dict: [String: Any?] = [:]
        dict["title"] = item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        dict["link"] = item.link
        dict["category"] = item.category
        dict["description"] = item.description
        dict["telephone"] = item.telephone
        dict["address"] = item.address
        dict["roadAddress"] = item.roadAddress
        dict["mapx"] = item.mapx
        dict["mapy"] = item.mapy
        
        db.collection("Store").document(item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)).setData(["group_code": groupCode, "data": dict])
    }
    
    func getStoreList(groupCode: String, completion: @escaping ([Any]?, Error?) -> Void) {
        let collectionRef = db.collection("Store")
        let query = collectionRef.whereField("group_code", isEqualTo: groupCode)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil, nil)
                return
            }
            
            let dataArray = snapshot.documents.compactMap { $0.data()["data"] }
            completion(dataArray, nil)
        }
    }
}
