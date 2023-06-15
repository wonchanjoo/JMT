//
//  AddStoreViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/14.
//

import UIKit
import NMapsMap
import Alamofire
import SwiftyJSON

class AddStoreViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
}

extension AddStoreViewController {
    @IBAction func searchStore(_ sender: UIButton) {
        let searchText = searchField.text
        
        // 한글도 검색될 수 있도록 URL Encoding
        let encodedSearchText = searchText?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "bAe2YtoL03nlWZpXQ6vE",
            "X-Naver-Client-Secret": "GQ_OzvU0Nx",
        ]
        
        // 검색 요청 -> 결과로 최대 5개의 장소를 받아온다.
        AF.request("https://openapi.naver.com/v1/search/local.json?query=" + encodedSearchText! + "&display=20&start=1&sort=random", headers: header).responseDecodable(of: SearchResult.self) { response in
            if let result = response.value {
                let items = result.items // 최대 5개의 장소
                for item in items {

                }
            }
        }
        
    }
}
