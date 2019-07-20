//
//  PlayerView.swift
//  YoutubeDemo
//
//  Created by Giresh Dora on 13/10/18.
//  Copyright © 2018 Giresh Dora. All rights reserved.
//
protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
}


import UIKit
import AVFoundation

class PlayerView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{

    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var minimizeButton: UIButton!
    @IBOutlet weak var player: UIView!
    //var video: Video!
    var delegate: PlayerVCDelegate?
    var state = stateOfVC.hidden
    var direction = Direction.none
    var videoPlayer = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    //MARK: View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
        self.videoPlayView()
    }
    
    //MARK: Methods
    func customization() {
        self.backgroundColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 90
        self.player.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
        self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.player.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapPlayView)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayView), name: NSNotification.Name("open"), object: nil)
    }
    
    func videoPlayView(){
        let videoURL = URL(string: "https://r5---sn-npoe7n7y.googlevideo.com/videoplayback?ei=TsHBW8blC4WhyAWk7ruwBQ&ip=5.19.250.92&id=o-ABSTKyM-VaM9JiM--8vE_2Xtwx-zylEhb0n5YHddaCbe&sparams=clen,dur,ei,expire,gir,id,ip,ipbits,ipbypass,itag,lmt,mime,mip,mm,mn,ms,mv,pl,ratebypass,requiressl,source&expire=1539446190&gir=yes&fvip=3&requiressl=yes&pl=23&ipbits=0&mime=video%2Fmp4&key=cms1&itag=18&lmt=1393812775866501&signature=5C4F9D071E440E3B6D14E6E7EB368ADC7CF30487.372FA8367EA1FEBBADF151A8ED4E1BD843192E42&ratebypass=yes&c=WEB&clen=10210667&source=youtube&dur=219.266&video_id=tvXUHY4z0As&title=Steve+Jobs+-+Apple+CEO+-+Mini+Bio+-+BIO&rm=sn-xguxaxjvh-8v1e7s,sn-xguxaxjvh-axqe7s,sn-axqdez&fexp=23763603&req_id=8c0fd3e6c8a4a3ee&redirect_counter=3&cms_redirect=yes&ipbypass=yes&mip=106.51.22.203&mm=30&mn=sn-npoe7n7y&ms=nxu&mt=1539424474&mv=m")!
        
        self.videoPlayer = AVPlayer(url:videoURL)
        playerLayer = AVPlayerLayer(player: self.videoPlayer)
        playerLayer.frame = self.player.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.player.layer.addSublayer(playerLayer)
        if self.state != .hidden {
            self.videoPlayer.play()
        }
    }
    
    func animate()  {
        switch self.state {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, animations: {
                self.minimizeButton.alpha = 1
                self.tableView.alpha = 1
                self.player.transform = CGAffineTransform.identity
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.minimizeButton.alpha = 0
                self.tableView.alpha = 0
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.player.bounds.width/4, y: -self.player.bounds.height/4))
                self.player.transform = trasform
            })
        default: break
        }
    }
    
    func changeValues(scaleFactor: CGFloat) {
        self.minimizeButton.alpha = 1 - scaleFactor
        self.tableView.alpha = 1 - scaleFactor
        let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
        let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.player.bounds.width / 4 * scaleFactor), y: -(self.player.bounds.height / 4 * scaleFactor)))
        self.player.transform = trasform
    }
    
    @objc func tapPlayView()  {
        self.videoPlayer.play()
        self.state = .fullScreen
        self.delegate?.didmaximize()
        self.animate()
        self.tableView.reloadData()
        playerLayer.frame = self.player.frame
    }
    
    @IBAction func minimize(_ sender: UIButton) {
        self.state = .minimized
        self.delegate?.didMinimize()
        self.animate()
    }
    
    @IBAction func minimizeGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                self.direction = .up
            } else {
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.changeValues(scaleFactor: factor)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
        case .minimized:
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.changeValues(scaleFactor: factor)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
            }
        default: break
        }
        if sender.state == .ended {
            self.state = finalState
            self.animate()
            self.delegate?.didEndedSwipe(toState: self.state)
            if self.state == .hidden {
                self.videoPlayer.pause()
            }
        }
    }
    
    //MARK: Delegate & dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate().sharedInstance().videoList?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header") as! headerCell
            cell.title.text = "iOS"
            cell.viewCount.text = "\(100000) views"
            cell.likes.text = "10000"
            cell.disLikes.text = "100"
            cell.channelTitle.text = "Steve Jobs"
            cell.channelPic.layer.cornerRadius = 25
            cell.channelPic.clipsToBounds = true
            cell.channelPic.image = UIImage.init(named: "stevejobs")
            cell.channelSubscribers.text = "\(100) subscribers"
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! videoCell
            let video = (AppDelegate().sharedInstance().videoList?.items?[indexPath.row])
            cell.name.text = video?.snippet?.title
            cell.title.text = video?.snippet?.channelTitle
            cell.tumbnail.imageFromServerURL(video?.snippet?.thumbnails?.medium?.url ?? "", placeHolder: UIImage.init(named: "emptyTumbnail"))
            return cell
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

class headerCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var disLikes: UILabel!
    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var channelPic: UIImageView!
    @IBOutlet weak var channelSubscribers: UILabel!
}

class videoCell: UITableViewCell {
    
    @IBOutlet weak var tumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var name: UILabel!
}
