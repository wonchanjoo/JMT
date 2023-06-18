//
//  CommentViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/19.
//

import UIKit

class CommentViewController: UIViewController {
    var store: Item!
    var database = Database()
    @IBOutlet weak var commentField: UITextField!
}

extension CommentViewController {
    @IBAction func addComment(_ sender: UIButton) {
        let content = commentField.text
        let nickname = UserDefaults.standard.object(forKey: "nickname") as? String
        let groupCode = UserDefaults.standard.object(forKey: "groupCode") as? String
        
        database.saveStore(groupCode: groupCode!, item: store, nickname: nickname!, content: content!)
        
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

