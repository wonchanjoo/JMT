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
}

extension GroupCodeViewController {
    override func viewDidLoad() {
        logoImageView.image = UIImage(named: "JMT_logo.png")
    }
}

extension GroupCodeViewController {
    @IBAction func createGroupCode(_ sender: UIButton) {
        let createGroupCodeDialog = storyboard?.instantiateViewController(withIdentifier: "CreateGroupCode") as! CreateGroupCodeViewController
        
        createGroupCodeDialog.modalPresentationStyle = .overCurrentContext
        createGroupCodeDialog.modalTransitionStyle = .crossDissolve
        createGroupCodeDialog.nickname = self.nickname
        
        self.present(createGroupCodeDialog, animated: true, completion: nil)
    }
    
    @IBAction func validGroupCode(_ sender: UIButton) {
    }
}
