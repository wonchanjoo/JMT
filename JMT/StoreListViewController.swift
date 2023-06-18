//
//  StoreListViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/16.
//

import UIKit
import PanModal

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
        
        let imageView = (cell.contentView.subviews[0] as! UIImageView)
        let titleLabel = (cell.contentView.subviews[1] as! UILabel)
        let categoryLabel = (cell.contentView.subviews[2] as! UILabel)
        let addressLabel = (cell.contentView.subviews[3] as! UILabel)
        let infoButton = (cell.contentView.subviews[4] as! UIButton)
        
        titleLabel.text = storeDict!["title"] as? String
        categoryLabel.text = storeDict!["category"] as? String
        addressLabel.text = storeDict!["address"] as? String
        
        if let categoryText = categoryLabel.text {
            if categoryText.contains("멕시코") {
                imageView.image = UIImage(named: "taco.png")
            } else if categoryText.contains("일식") {
                imageView.image = UIImage(named: "sushi.png")
            } else if categoryText.contains("카페") {
                imageView.image = UIImage(named: "hot-beverage.png")
            } else if categoryText.contains("양식") {
                imageView.image = UIImage(named: "spaghetti.png")
            } else {
                imageView.image = UIImage(named: "fork-and-knife.png")
            }
        }
        
        let clickButtonGesture = UITapGestureRecognizer(target: self, action: #selector(showStoreInfo(_:)))
        infoButton.addGestureRecognizer(clickButtonGesture)
        
        return cell
    }
}

extension StoreListViewController {
    @objc func showStoreInfo(_ gesture: UITapGestureRecognizer) {
        // 버튼이 속한 cell의 title 값 가져오기
        guard let button = gesture.view as? UIButton else {
            return
        }
        guard let cell = button.superview?.superview as? UITableViewCell else {
            return
        }
        guard let indexPath = storeTableView.indexPath(for: cell) else {
            return
        }
        let storeDict = storeList[indexPath.row]
        let title = storeDict?["title"] as! String
        
        // 데이터베이스에서 가져온 store 정보 StoreViewController에 저장 후 전환
        database.getStoreInfo(title: title) { storeInfo in
            let storeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Store") as! StoreViewController
            storeViewController.modalPresentationStyle = .fullScreen
            storeViewController.storeInfo = storeInfo
            self.present(storeViewController, animated: true, completion: nil)
        }
    }
}

extension StoreListViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(UIScreen.main.bounds.height * 0.4)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(0)
    }
}
