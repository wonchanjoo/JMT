//
//  User.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/08.
//

import Foundation

class User: NSObject, NSCoding {
    var key: String
    var nickname: String
    var password: String
    
    init(nickname: String, password: String) {
        self.key = UUID().uuidString
        self.nickname = nickname
        self.password = password
        super.init()
    }
    
    // user 정보 archiving
    func encode(with coder: NSCoder) {
        coder.encode(key, forKey: "key")
        coder.encode(nickname, forKey: "nickname")
        coder.encode(password, forKey: "password")
    }
    
    // user 정보 unarchiving
    required init(coder: NSCoder) {
        key = coder.decodeObject(forKey: "key") as! String? ?? ""
        nickname = coder.decodeObject(forKey: "nickname") as! String? ?? ""
        password = coder.decodeObject(forKey: "password") as! String? ?? ""
        super.init()
    }
}
