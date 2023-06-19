//
//  SignUpViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/08.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    let database = Database()
}

extension SignUpViewController {
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let nickname = nicknameField.text!
        let password = passwordField.text!
        
        if nickname != "" && password != "" {
            let user = User(nickname: nickname, password: password)
            database.saveUser(user: user)
            dismiss(animated: true)
        } else {
            errorMessage.layer.isHidden = false
        }
    }
}
