//
//  SideMenuViewController.swift
//  JMT
//
//  Created by 원찬주 on 2023/06/14.
//

import UIKit

class SideMenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var items = ["그룹 정보", "맛집 리스트"]
}

extension SideMenuViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            
        } else if indexPath.row == 2 {
            
        }
    }
}
