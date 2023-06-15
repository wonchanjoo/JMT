//
//  MainViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/14.
//

import UIKit
import NMapsMap

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
    }
}

extension MainViewController {
    @IBAction func addStore(_ sender: UIBarButtonItem) {
        let addStoreViewController = storyboard?.instantiateViewController(withIdentifier: "AddStore") as! AddStoreViewController
        
        navigationController?.pushViewController(addStoreViewController, animated: true)
    }
}
