//
//  StoreViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/18.
//

import UIKit

class StoreViewController: UIViewController {
    var storeInfo: [String: Any?]!
    var comments: [String]!
    let database = Database()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telephoneImage: UIImageView!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentField: UITextField!
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
        
        commentTableView.dataSource = self
    }
}

extension StoreViewController {
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addComment(_ sender: UIButton) {
        let title = storeInfo["title"] as? String
        let nickname = UserDefaults.standard.object(forKey: "nickname")
        let content = commentField.text!
        
        database.addComment(title: title!, nickname: nickname as! String, content: content) { (error) in
            self.commentField.text = ""
            self.database.getComments(title: title!) { (comments) in
                self.comments = comments
                self.commentTableView.reloadData()
            }
        }
    }
}

extension StoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comment = self.comments {
            return comment.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell")!
        
        let comment = comments![indexPath.row]
        let components = comment.components(separatedBy: ":")
        
        let userImage = (cell.contentView.subviews[0] as! UIImageView)
        let nicknameLabel = (cell.contentView.subviews[1] as! UILabel)
        let contentLabel = (cell.contentView.subviews[2] as! UILabel)
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
        database.downloadImage(nickname: components[0]) { img in
            userImage.image = img
        }
        
        nicknameLabel.text = components[0]
        contentLabel.text = components[1]
        
        return cell
    }
}
