//
//  AddStoreViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/14.
//

import UIKit
import NMapsMap
import Alamofire

class AddStoreViewController: UIViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapView: NMFMapView!
    @IBOutlet weak var storeTableView: UITableView!
    var items: [Item]?
}

extension AddStoreViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeTableView.dataSource = self
    }
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
                self.items = result.items // 장소 저장
                self.storeTableView.reloadData()
                self.showMakers()
            }
        }
        
    }
    
    // items 저장된 가게들의 마커 표시
    func showMakers() {
        var lastPosition: NMGLatLng!
        
        // 마커 생성해서 표시
        guard let items = self.items else { return }
        for item in items {
            let position = NMGTm128(x: Double(item.mapx)!, y: Double(item.mapy)!).toLatLng()
            lastPosition = position
            
            let marker = NMFMarker(position: position)
            marker.iconImage = NMF_MARKER_IMAGE_BLUE
            marker.captionText = item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            marker.mapView = mapView // 마커 표시
        }
        
        // 지도 위치를 items의 마지막 가게의 위치로 업데이트
        var updateCamera = NMFCameraUpdate(scrollTo: lastPosition)
        updateCamera.animation = .easeOut
        mapView.moveCamera(updateCamera)
    }
}

extension AddStoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = self.items {
            return items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell")!
        let item = items![indexPath.row]
        
        (cell.contentView.subviews[0] as! UILabel).text = item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        (cell.contentView.subviews[1] as! UILabel).text = item.category
        
        return cell
    }
}

extension AddStoreViewController: UITableViewDelegate {
    
}
