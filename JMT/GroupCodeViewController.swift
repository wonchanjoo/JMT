//
//  GroupCodeViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/07.
//

import UIKit

class GroupCodeViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var groupCodeField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var copyMessage: UILabel!
    var nickname: String!
    var database = Database()
}

extension GroupCodeViewController {
    override func viewDidLoad() {
        logoImageView.image = UIImage(named: "JMT_logo.png")
        errorMessage.isHidden = true
        nickname = UserDefaults.standard.object(forKey: "nickname") as! String
    }
}

extension GroupCodeViewController {
    @IBAction func createGroupCode(_ sender: UIButton) {
        let createGroupCodeDialog = storyboard?.instantiateViewController(withIdentifier: "CreateGroupCode") as! CreateGroupCodeViewController
        
        createGroupCodeDialog.modalPresentationStyle = .overCurrentContext
        createGroupCodeDialog.modalTransitionStyle = .crossDissolve
        createGroupCodeDialog.nickname = self.nickname
        createGroupCodeDialog.showToast = showToast(message:font:)
        
        self.present(createGroupCodeDialog, animated: true, completion: nil)
    }
    
    @IBAction func validGroupCode(_ sender: UIButton) {
        let groupCode = groupCodeField.text
        
        if groupCode == "" {
            errorMessage.text = "그룹 코드를 입력하세요"
            errorMessage.isHidden = false
        } else {
            database.getGroupList { (groupList, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let groupList = groupList {
                    let documentExists = groupList.contains { $0.documentID == groupCode }
                    if documentExists { // 그룹 코드가 존재하는 경우
                        // UserDefaults에 그룹 코드만 저장
                        UserDefaults.standard.set(groupCode, forKey: "groupCode")
                        
                        // Group에 user 추가
                        self.database.addGroupUser(code: groupCode!, nickname: UserDefaults.standard.object(forKey: "nickname") as! String)
                        
                        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                        tabBarController.modalPresentationStyle = .fullScreen
                        tabBarController.modalTransitionStyle = .coverVertical
                        
                        self.present(tabBarController, animated: true, completion: nil)
                    } else { // 그룹 코드가 존재하지 않는 경우
                        self.errorMessage.text = "존재하지 않는 그룹 코드입니다"
                        self.errorMessage.isEnabled = false
                    }
                }
            }
        }

    }
}

extension GroupCodeViewController {
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
