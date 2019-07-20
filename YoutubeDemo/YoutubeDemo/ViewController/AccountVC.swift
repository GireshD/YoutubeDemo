//
//  AccountVC.swift
//  YoutubeDemo
//
//  Created by Giresh Dora on 12/10/18.
//  Copyright © 2018 Giresh Dora. All rights reserved.
//

import UIKit

class AccountVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    //MARK: - Properties
   
    @IBOutlet weak var tableView: UITableView!
    let menuTitles = ["History", "My Videos", "Notifications", "Watch Later"]
    var items = 5
   
    var lastContentOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "tapMenu"), object: nil, userInfo: ["length": 3])
    }
    
    
    
    //MARK: Methods
    
    func customization() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
        
    }
    
    // MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! AccountHeaderCell
            cell.name.text = "Steve Jobs"
            cell.profilePic.image = UIImage.init(named: "stevejobs")
            return cell
        case 1...4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath) as! AccountMenuCell
            cell.menuTitles.text = self.menuTitles[indexPath.row - 1]
            cell.menuIcon.image = UIImage.init(named: self.menuTitles[indexPath.row - 1])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Menu", for: indexPath) as! AccountMenuCell
            return cell
        }
    }
}
