//
//  ViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/01.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    let database = Database()
}

extension StartViewController {
    override func viewDidLoad() {
        logoImageView.image = UIImage(named: "JMT_logo.png")
        passwordField.isSecureTextEntry = true
        errorMessage.isHidden = true
    }
}

extension StartViewController {
    @IBAction func signup(_ sender: UIButton) {
        let signUpDialog = storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        
        signUpDialog.modalPresentationStyle = .overCurrentContext
        signUpDialog.modalTransitionStyle = .crossDissolve
        
        self.present(signUpDialog, animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: UIButton) {
        let nickname = nicknameField.text
        let password = passwordField.text
        
        if nickname == "" || password == "" {
            errorMessage.text = "올바른 값을 입력하세요"
            errorMessage.isHidden = false
        } else {
            database.validUser(nickname: nickname!, password: password!) { valid in
                if valid { // 로그인 성공
                    self.database.haveGroupCode(nickname: nickname!) { haveGroup in
                        if haveGroup { // 그룹 코드가 이미 있는 경우
                            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                            tabBarController.modalPresentationStyle = .fullScreen
                            
                            self.database.getGroupCode(nickname: nickname!) { groupCode in
                                // UserDefaults로 닉네임과 그룹 코드 저장
                                UserDefaults.standard.set(groupCode, forKey: "groupCode")
                                UserDefaults.standard.set(nickname, forKey: "nickname")

                                self.present(tabBarController, animated: true, completion: nil)
                            }
                        } else { // 그룹 코드가 없는 경우
                            // UserDefaults로 닉네임만 저장
                            UserDefaults.standard.set(nickname, forKey: "nickname")
                            
                            let groupCodeViewController = self.storyboard?.instantiateViewController(withIdentifier: "GroupCode") as! GroupCodeViewController
                            
                            self.navigationController?.pushViewController(groupCodeViewController, animated: true)
                        }
                    }
                } else { // 로그인 실패
                    self.errorMessage.text = "계정이 존재하지 않거나 비밀번호가 틀렸습니다"
                    self.errorMessage.isHidden = false
                }
            }
        }
    }
}
