//
//  SettingViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/18.
//

import UIKit

class SettingViewController: UIViewController {
    let database = Database()
    
    @IBOutlet weak var userImage: UIImageView!
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
