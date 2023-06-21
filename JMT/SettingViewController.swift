//
//  SettingViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/18.
//

import UIKit

class SettingViewController: UIViewController {
    let database = Database()
    
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupCodeLabel: UILabel!
    
    
    @IBAction func copyGroupCode(_ sender: UIButton) {
        UIPasteboard.general.string = UserDefaults.standard.object(forKey: "groupCode") as! String
        showToast(message: "그룹코드가 복사 되었습니다", font: UIFont.systemFont(ofSize: 15))
    }
}

extension SettingViewController {
    override func viewDidLoad() {
        // imageView 설정
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateUserImage)))
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        database.downloadImage(nickname: UserDefaults.standard.object(forKey: "nickname") as! String) { img in
            self.userImage.image = img
        }
        
        nicknameLabel.text = UserDefaults.standard.object(forKey: "nickname") as! String
        
        groupView.layer.cornerRadius = 10
        groupCodeLabel.text = UserDefaults.standard.object(forKey: "groupCode") as! String
        database.getGroupName(groupCode: UserDefaults.standard.object(forKey: "groupCode") as! String) { groupName in
            self.groupNameLabel.text = groupName
            
        }
    }
}

extension SettingViewController {
    @objc func updateUserImage(sender: UITapGestureRecognizer) {
        // 컨트롤러 생성
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
                
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 250, height: 35))
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

extension SettingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // 앨범에서 사진 선택
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        userImage.image = image // UIImageView 업데이트
        database.uploadImage(img: image, nickname: UserDefaults.standard.object(forKey: "nickname") as! String)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 사진 선택 취소
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
