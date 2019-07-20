//
//  HomeVideoCell.swift
//  YoutubeDemo
//
//  Created by Giresh Dora on 12/10/18.
//  Copyright © 2018 Giresh Dora. All rights reserved.
//

import UIKit

class HomeVideoCell: UITableViewCell {

    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var channelPic: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
    }
    
    func customization()  {
        self.channelPic.layer.cornerRadius = 24
        self.channelPic.clipsToBounds  = true
    }
    
    func set(video: Items)  {
        self.videoThumbnail.imageFromServerURL(video.snippet?.thumbnails?.medium?.url ?? "", placeHolder: UIImage.init(named: "emptyTumbnail"))
        self.videoTitle.text = video.snippet?.channelTitle
        self.videoDescription.text = video.snippet?.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.videoThumbnail.image = UIImage.init(named: "emptyTumbnail")
        self.channelPic.image = nil
        self.videoTitle.text = nil
        self.videoDescription.text = nil
    }
    
    

}
