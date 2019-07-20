//
//  NavVC.swift
//  YoutubeDemo
//
//  Created by Giresh Dora on 12/10/18.
//  Copyright © 2018 Giresh Dora. All rights reserved.
//

import UIKit

class NavVC: UINavigationController, PlayerVCDelegate {

    //MARK: Properties
    @IBOutlet var playerView: PlayerView!
    let titleLabel = UILabel()
    let names = ["Home", "Trending", "Subscriptions", "Account"]
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let minimizedOrigin: CGPoint = {
        let x = UIScreen.main.bounds.width/2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.playerView)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Methods
    func customization() {
        
        //TitleLabel setup
        self.titleLabel.font = UIFont.systemFont(ofSize: 18)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.text = self.names[0]
        self.navigationBar.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let _ = NSLayoutConstraint.init(item: self.navigationBar, attribute: .centerY, relatedBy: .equal, toItem: self.titleLabel, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: self.navigationBar, attribute: .height, relatedBy: .equal, toItem: self.titleLabel, attribute: .height, multiplier: 1.0, constant: 0).isActive = true
        let _ = NSLayoutConstraint.init(item: self.navigationBar, attribute: .left, relatedBy: .equal, toItem: self.titleLabel, attribute: .left, multiplier: 1.0, constant: -10).isActive = true
        self.titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        //NavigationBar color and shadow
        self.navigationBar.barTintColor = UIColor.rbg(r: 228, g: 34, b: 24)
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationItem.hidesBackButton = true
        
        //PLayerView setup
        self.playerView.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        self.playerView.delegate = self
        //NotificaionCenter Setup
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeTitle(notification:)), name: Notification.Name.init(rawValue: "tapMenu"), object: nil)
      
    }
    
    @objc func changeTitle(notification: Notification)  {
        if let info = notification.userInfo {
            let userInfo = info as! [String: Any]
            self.titleLabel.text = self.names[Int(round(Double(userInfo["length"]! as! Int)))]
        }
    }
    @objc func hideBar(notification: NSNotification)  {
        let state = notification.object as! Bool
        self.navigationController?.setNavigationBarHidden(state, animated: true)
    }
    
    
    func animatePlayView(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.beginFromCurrentState], animations: {
                self.playerView.frame.origin = self.fullScreenOrigin
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.minimizedOrigin
            })
        case .hidden:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.hiddenOrigin
            })
        }
    }

    //MARK: Delegate methods
    func didMinimize() {
        self.animatePlayView(toState: .minimized)
    }
    
    func didmaximize(){
        self.animatePlayView(toState: .fullScreen)
    }
    
    func didEndedSwipe(toState: stateOfVC){
        self.animatePlayView(toState: toState)
    }
    
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC){
        switch toState {
        case .fullScreen:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        case .hidden:
            self.playerView.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
        case .minimized:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        }
    }
    
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
}
