//
//  StoreListViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/16.
//

import UIKit

class StoreListViewController: UIViewController {
    @IBOutlet weak var storeTableView: UITableView!
    var groupCode: String!
    var database = Database()
    var storeList: [[String: Any]?]!
}

extension StoreListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupCode = UserDefaults.standard.object(forKey: "groupCode") as! String
        
        // 가게 정보 딕셔너리를 배열로 가져와서 storeList에 저장
        database.getStoreList(groupCode: groupCode) { (dataArray, error) in
            if let error = error {
                print("getStoreList Error: \(error)")
                return
            }
            
            if let dataArray = dataArray {
                self.storeList = Array(repeating: nil, count: dataArray.count)
                for i in 0..<dataArray.count {
                    if let dataDict = dataArray[i] as? [String: Any] {
                        self.storeList[i] = dataDict
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.storeTableView.reloadData() // 테이블 뷰 업데이트
            }
        }
        
        storeTableView.dataSource = self
    }
}

extension StoreListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let storeList = self.storeList {
            return storeList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell")!
        let storeDict = storeList[indexPath.row]
        
        let titleLabel = (cell.contentView.subviews[1] as! UILabel)
        let categoryLabel = (cell.contentView.subviews[2] as! UILabel)
        let addressLabel = (cell.contentView.subviews[3] as! UILabel)
        
        titleLabel.text = storeDict!["title"] as? String
        categoryLabel.text = storeDict!["category"] as? String
        addressLabel.text = storeDict!["address"] as? String
        
        return cell
    }
}
