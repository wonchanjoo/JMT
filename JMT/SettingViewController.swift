//
//  SettingViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/18.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
}

extension SettingViewController {
    override func viewDidLoad() {
        userImage.image = UIImage(systemName: "person.fill")
    }
}
