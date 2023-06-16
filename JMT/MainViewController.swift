//
//  MainViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/14.
//

import UIKit
import NMapsMap

class MainViewController: UIViewController {
    var groupCode: String!
    var database = Database()
    var makers: [NMFMarker?]! // 화면에 있는 마커들 저장
    var mapView: NMFMapView!
}

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupCode = UserDefaults.standard.object(forKey: "groupCode") as! String
        
        // mapView 추가
        mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        
        // 데이터베이스에 저장된 store들의 마커 찍기
        database.getStoreList(groupCode: groupCode) { dataArray, error in
            if let error = error {
                print("getStoreList Error: \(error)")
                return
            }
            
            if let dataArray = dataArray {
                for data in dataArray {
                    if let dataDict = data as? [String: Any] {
                        self.showMarker(dict: dataDict)
                    }
                }
            }
        }
        
        // 지도에 서울 전체가 보이도록
        let seoulBounds = NMGLatLngBounds(southWest: NMGLatLng(lat: 37.413294, lng: 126.734086),
                                                  northEast: NMGLatLng(lat: 37.715133, lng: 127.269311))
        mapView.moveCamera(NMFCameraUpdate(fit: seoulBounds))
    }
}

extension MainViewController {
    // AddStoreViewController로 이동
    @IBAction func addStore(_ sender: UIBarButtonItem) {
        let addStoreViewController = storyboard?.instantiateViewController(withIdentifier: "AddStore") as! AddStoreViewController
        navigationController?.pushViewController(addStoreViewController, animated: true)
    }
}

extension MainViewController {
    // 전달된 딕셔너리의 좌표 정보를 가지고 mapView에 marker 생성
    func showMarker(dict: [String: Any]) {
        let title = dict["title"] as? String
        let mapx = (dict["mapx"] as? String)!
        let mapy = (dict["mapy"] as? String)!
        
        let position = NMGTm128(x: Double(mapx)!, y: Double(mapy)!).toLatLng()
        
        // 마커 생성
        let marker = NMFMarker(position: position)
        marker.iconImage = NMF_MARKER_IMAGE_BLUE
        marker.width = 20
        marker.height = 25
        marker.captionText = title!
        marker.captionRequestedWidth = 10
        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
            var updateCamera = NMFCameraUpdate(scrollTo: position)
            self.mapView.moveCamera(updateCamera)
            return true
        }
        marker.mapView = mapView
    }
}
