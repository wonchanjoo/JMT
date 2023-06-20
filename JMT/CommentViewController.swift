//
//  CommentViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/19.
//

import UIKit
import Alamofire
import Kingfisher

class CommentViewController: UIViewController {
    var store: Item!
    var database = Database()
    var showToast: ((String, UIFont) -> Void)!
    
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
}

extension CommentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButton.tintColor = UIColor(red: 0.478, green: 0.376, blue: 0.878, alpha: 1.0)
        okButton.layer.cornerRadius = 10
        
        cancelButton.tintColor = UIColor(red: 0.713, green: 0.692, blue: 1.000, alpha: 1.0)
        cancelButton.layer.cornerRadius = 10
    }
}

extension CommentViewController {
    @IBAction func addComment(_ sender: UIButton) {
        let content = commentField.text
        let nickname = UserDefaults.standard.object(forKey: "nickname") as? String
        let groupCode = UserDefaults.standard.object(forKey: "groupCode") as? String
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "bAe2YtoL03nlWZpXQ6vE",
            "X-Naver-Client-Secret": "GQ_OzvU0Nx",
        ]
        
        // 한글도 검색될 수 있도록 URL Encoding
        let encodedSearchText = store.title.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        AF.request("https://openapi.naver.com/v1/search/image?query=" + encodedSearchText! + "&display=3&start=1&sort=sim", headers: header).responseDecodable(of: SearchImageResult.self) { response in
            if let result = response.value {
                let imageItem = result.items
                let images = [imageItem[0].link, imageItem[1].link, imageItem[2].link]
                self.database.saveStore(groupCode: groupCode!, item: self.store, images: images, nickname: nickname!, content: content!)
            }
        }
        
        showToast("추가 되었습니다!", UIFont.systemFont(ofSize: 15))
        dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

