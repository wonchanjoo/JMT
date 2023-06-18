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
    var database = Database()
    var groupCode: String!
    var items: [Item]?
    var markers: [NMFMarker?]! // 화면에 있는 마커들 저장
    var latLngArray: [NMGLatLng?]! // 화면에 있는 마커들의 위치 저장
}

extension AddStoreViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeTableView.dataSource = self
        groupCode = UserDefaults.standard.object(forKey: "groupCode") as! String
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
                self.showMarkers()
            }
        }
        
    }
    
    // items 저장된 가게들의 마커 표시
    func showMarkers() {
        removeMarkers() // 전에 있던 마커 삭제
    
        latLngArray = Array(repeating: nil, count: items!.count) // 마커의 좌표 배열
        markers = Array(repeating: nil, count: items!.count) // 마커 배열
        
        // 마커 생성해서 표시
        guard let items = self.items else { return }
        for i in 0..<items.count {
            let item = items[i]
            
            let position = NMGTm128(x: Double(item.mapx)!, y: Double(item.mapy)!).toLatLng() // 가게의 좌표
            latLngArray[i] = position // 좌표 저장
            
            // 마커 생성
            let marker = NMFMarker(position: position)
            marker.iconImage = NMF_MARKER_IMAGE_BLUE
            marker.width = 20
            marker.height = 25
            marker.captionText = item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            marker.captionRequestedWidth = 10
            marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                // link가 존재하면 WebViewController로 이동
                if item.link != "" {
                    print("link = \(item.link)")
                    let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "Web") as! WebViewController
                    webViewController.link = item.link
                    self.present(webViewController, animated: true, completion: nil)
                }
                return true
            }
            marker.mapView = mapView // 마커 지도에 표시
            
            markers![i] = marker // 마커 저장
        }
        
        // 지도 위치 업데이트
        var bounds = NMGLatLngBounds(southWest: findSouthwest(latLngArray), northEast: findNorthEast(latLngArray))
        var updateCamera = NMFCameraUpdate(fit: bounds, padding: CGFloat(80))
        updateCamera.animation = .fly
        mapView.moveCamera(updateCamera)
    }
    
    // 전에 표시한 마커들 삭제
    func removeMarkers() {
        guard let markers = self.markers else { return }
        for marker in markers {
            marker!.mapView = nil
        }
    }
    
    // 가장 북서쪽 좌표
    func findSouthwest(_ latLngArray: [NMGLatLng?]) -> (NMGLatLng) {
        var southWest = latLngArray.first!
        
        for coordinate in latLngArray {
            if coordinate!.lat < southWest!.lat {
                southWest = coordinate
            }
            
            if coordinate!.lng < southWest!.lng {
                southWest = coordinate
            }
        }
        
        return southWest!
    }
    
    // 가장 동남쪽 좌표
    func findNorthEast(_ latLngArray: [NMGLatLng?]) -> (NMGLatLng) {
        var northEast = latLngArray.first!
        
        for coordinate in latLngArray {
            if coordinate!.lat > northEast!.lat {
                northEast = coordinate
            }
            if coordinate!.lng > northEast!.lng {
                northEast = coordinate
            }
        }
        
        return northEast!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddStoreTableViewCell")!
        let item = items![indexPath.row]
        
        let titleLabel = (cell.contentView.subviews[0] as! UILabel)
        let categoryLabel = (cell.contentView.subviews[1] as! UILabel)
        let addressLabel = (cell.contentView.subviews[2] as! UILabel)
        let addButton = (cell.contentView.subviews[3] as! UIButton)
        
        titleLabel.text = item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        titleLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveMarker(_:)))
        titleLabel.addGestureRecognizer(tapGesture)
        
        categoryLabel.text = item.category
        addressLabel.text = item.address
        
        let clickButtonGesture = UITapGestureRecognizer(target: self, action: #selector(addStore(_:)))
        addButton.addGestureRecognizer(clickButtonGesture)
        
        return cell
    }
}

extension AddStoreViewController {
    @objc func moveMarker(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: storeTableView)
        if let tappedIndexPath = storeTableView.indexPathForRow(at: tapLocation) {
            let item = items![tappedIndexPath.row]
            
            // 지도 이동
            var updateCamera = NMFCameraUpdate(scrollTo: latLngArray[tappedIndexPath.row]!)
            updateCamera.animation = .easeIn
            mapView.moveCamera(updateCamera)
        }
    }
    
    @objc func addStore(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: storeTableView)
        if let tappedIndexPath = storeTableView.indexPathForRow(at: tapLocation) {
            let item = items![tappedIndexPath.row]
            database.saveStore(groupCode: groupCode, item: item)
        }
    }
}
