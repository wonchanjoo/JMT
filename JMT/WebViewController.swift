//
//  WebViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/15.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var link: String!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
