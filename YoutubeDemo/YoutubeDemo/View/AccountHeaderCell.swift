//
//  AccountHeaderCell.swift
//  YoutubeDemo
//
//  Created by Giresh Dora on 13/10/18.
//  Copyright © 2018 Giresh Dora. All rights reserved.
//

import UIKit

class AccountHeaderCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePic.layer.cornerRadius = 25
        self.profilePic.clipsToBounds = true
    }

}
