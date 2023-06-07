//
//  ViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/01.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var errorMessage: UILabel!
}

extension StartViewController {
    override func viewDidLoad() {
        logoImageView.image = UIImage(named: "JMT_logo.png")
    }
}

extension StartViewController {
    @IBAction func validCode(_ sender: UIButton) {
    }
    
    @IBAction func createCode(_ sender: Any) {
        // GroupCodeDialog를 띄운다.
        let groupCodeDialog = storyboard?.instantiateViewController(withIdentifier: "GroupCodeDialog") as! GroupCodeViewController
        groupCodeDialog.modalPresentationStyle = .overCurrentContext
        groupCodeDialog.modalTransitionStyle = .crossDissolve
        
        self.present(groupCodeDialog, animated: true, completion: nil)
        
        // uuid를 만든다.
        //let code = UIDevice.current.identifierForVendor!.uuidString
        
        // 만든 code를 클립보드에 복사한다.
        //UIPasteboard.general.string = code
        
        // 데이터베이스에 코드 추가
        
        // 화면 이동
    }
}
