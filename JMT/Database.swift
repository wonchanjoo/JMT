//
//  Database.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/07.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class Database {
    let db = Firestore.firestore()
    let storage = Storage.storage()
}


// user
extension Database {
    func saveUser(user: User) {
        // fire store에 user 정보 저장
        let data = try? NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
        db.collection("User").document(user.nickname).setData(["data": data as Any])
        
        // storage에 user 기본 이미지 저장
        uploadImage(img: UIImage(systemName: "person.fill")!, nickname: user.nickname)
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
    // 새로운 그룹 저장
    func saveGroupCode(code: String, name: String) {
        db.collection("Group").document(code).setData(["name": name])
    }
    
    // 그룹에 user 추가
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
    
    // 모든 그룹 이름 반환
    func getGroupList(completion: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
        db.collection("Group").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("getGroupList error: \(error.localizedDescription)")
                completion(nil, error)
            } else {
                guard let groupList = querySnapshot?.documents else {
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
    // 새로운 가게 저장
    func saveStore(groupCode: String, item: Item, nickname: String, content: String) {
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
        
        var comment: [String] = ["\(nickname):\(content)"]
        
        db.collection("Store").document(item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)).setData(["group_code": groupCode, "data": dict, "comment": comment])
    }
    
    // 모든 가게 반환
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
    
    // title 가게의 정보 반환(title, category, address 등..)
    func getStoreInfo(title: String, completion: @escaping ([String: Any?]?, [String]?) -> Void) {
        let ref = db.collection("Store").document(title)
        ref.getDocument { (document, error) in
            if let data = document?.data()?["data"], let comment = document?.data()?["comment"] {
                completion(data as? [String: Any?], comment as? [String])
            } else {
                completion(nil, nil)
            }
            
        }
    }
    
    // title 가게의 코멘트 배열 가져오기
    func getComments(title: String, completion: @escaping ([String]?) -> Void) {
        let ref = db.collection("Store").document(title)
        ref.getDocument { (document, error) in
            if let comments = document?.data()?["comment"] {
                completion(comments as! [String])
            } else {
                completion(nil)
            }
        }
    }
    
    // title 가게에 코멘트 추가
    func addComment(title: String, nickname: String, content: String, completion: @escaping (Error?) -> Void) {
        db.collection("Store").document(title).getDocument { (document, error) in
            if let document = document, document.exists {
                var comments = document.data()?["comment"] as? [String] ?? []
                comments.append("\(nickname):\(content)") // add new comment
                self.db.collection("Store").document(title).updateData(["comment": comments]) // DB에 저장
                completion(nil)
            }
        }
    }
}


// 이미지
extension Database {
    func uploadImage(img: UIImage, nickname: String) {
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        storage.reference().child(nickname).putData(data, metadata: metaData) { (metaData, error) in
            if let error = error {
                return
            } else {
                
            }
        }
    }
    
    func downloadImage(nickname: String, completion: @escaping (UIImage?) -> Void) {
        storage.reference(forURL: "gs://jmt-ios-d463c.appspot.com/\(nickname)").getData(maxSize: Int64(1 * 1024 * 1024)) { data, error in
            guard let imgData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imgData))
        }
    }

}
