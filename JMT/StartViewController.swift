//
//  ViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/01.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
}

extension StartViewController {
    override func viewDidLoad() {
        logoImageView.image = UIImage(named: "JMT_logo.png")
    }
}

extension StartViewController {
    @IBAction func signup(_ sender: UIButton) {
        let signUpDialog = storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        
        signUpDialog.modalPresentationStyle = .overCurrentContext
        signUpDialog.modalTransitionStyle = .crossDissolve
        
        self.present(signUpDialog, animated: true, completion: nil)
    }
}
