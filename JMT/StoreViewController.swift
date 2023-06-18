//
//  StoreViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/18.
//

import UIKit

class StoreViewController: UIViewController {
    var storeInfo: [String: Any?]!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telephoneImage: UIImageView!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    
    @IBOutlet weak var addressStackView: UIStackView!
    @IBOutlet weak var telephoneStackView: UIStackView!
    @IBOutlet weak var linkStackView: UIStackView!
}

extension StoreViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = storeInfo["title"] as? String
        
        let categoryText = storeInfo["category"] as? String
        let components = categoryText?.components(separatedBy: ">")
        if let last = components?.last {
            categoryLabel.text = last
        } else {
            categoryLabel.text = ""
        }

        addressImage.image = UIImage(systemName: "location.north.fill")
        addressLabel.text = storeInfo["address"] as? String
        
        telephoneImage.image = UIImage(systemName: "phone")
        telephoneLabel.text = storeInfo["telephone"] as? String
        
        linkImage.image = UIImage(systemName: "house")
        linkLabel.text = storeInfo["link"] as? String
    }
}

extension StoreViewController {
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

