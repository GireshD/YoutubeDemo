//
//  SubscriptionsVC.swift
//  YoutubeDemo
//
//  Created by Giresh Dora on 12/10/18.
//  Copyright © 2018 Giresh Dora. All rights reserved.
//

import UIKit

class SubscriptionsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "tapMenu"), object: nil, userInfo: ["length": 2])
    }


}
