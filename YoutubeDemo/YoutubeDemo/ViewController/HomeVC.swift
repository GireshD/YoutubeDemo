//
//  HomeVC.swift
//  YoutubeDemo
//
//  Created by Giresh Dora on 12/10/18.
//  Copyright © 2018 Giresh Dora. All rights reserved.
//

import UIKit

class HomeVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var lastContentOffset: CGFloat = 0.0
    //var videoList : VideoDetailsList?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        ANLoader.showLoading()
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideBar(notification:)), name: NSNotification.Name("hide"), object: nil)
        let str = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&chart=mostPopular&maxResults=50"
        
        APIManager.sharedInstance.getVideoList(str: str) { (videoDetailList, error) in
            DispatchQueue.main.async {
                if let videoDetailList = videoDetailList{
                    AppDelegate().sharedInstance().videoList = videoDetailList
                    self.tableView.reloadData()
                    ANLoader.hide()
                }else{
                    self.tableView.reloadData()
                    ANLoader.hide()
                    self.showAlart()
                }
                
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "tapMenu"), object: nil, userInfo: ["length": 0])
    }
    @objc func hideBar(notification: NSNotification)  {
        let state = notification.object as! Bool
        self.navigationController?.setNavigationBarHidden(state, animated: true)
    }
    
    //MARK: Methods
    func customization() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate().sharedInstance().videoList?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVideoCell") as! HomeVideoCell
        if let item = AppDelegate().sharedInstance().videoList?.items{
            cell.set(video: (AppDelegate().sharedInstance().videoList?.items?[indexPath.row])!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let items = AppDelegate().sharedInstance().videoList?.items{
            if items.count > 0{
                if (self.lastContentOffset > scrollView.contentOffset.y) {
                    NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name("hide"), object: true)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lastContentOffset = scrollView.contentOffset.y;
    }
    
    func showAlart(){
        let alert = UIAlertController(title: "Alert", message: "Please check internet connection", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
