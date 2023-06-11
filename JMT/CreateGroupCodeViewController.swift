//
//  CreateGroupCodeViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/10.
//

import UIKit

class CreateGroupCodeViewController: UIViewController {
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    var nickname: String!
    var database = Database()
}


extension CreateGroupCodeViewController {
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func createGroupCode(_ sender: UIButton) {
        if groupNameField.text == "" {
            errorMessage.isHidden = false
        } else {
            let groupCode = UIDevice.current.identifierForVendor?.uuidString
            database.saveGroupCode(code: groupCode!, name: nickname)
            dismiss(animated: true)
        }
    }
}
