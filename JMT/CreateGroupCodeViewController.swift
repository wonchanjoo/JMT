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
    var showToast: ((String, UIFont) -> Void)!
}


extension CreateGroupCodeViewController {
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func createGroupCode(_ sender: UIButton) {
        if groupNameField.text == "" {
            errorMessage.isHidden = false
        } else {
            let groupCode = UIDevice.current.identifierForVendor?.uuidString // group code 생성
            
            database.saveGroupCode(code: groupCode!, name: groupNameField.text!) // DB에 groupcode 저장
            
            UIPasteboard.general.string = groupCode // 클립보드에 복사
            showToast("그룹 코드가 클립보드에 복사되었습니다", UIFont.systemFont(ofSize: 15))
            
            dismiss(animated: true)
        }
    }
}
