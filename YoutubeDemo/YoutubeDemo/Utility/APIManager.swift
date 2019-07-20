//
//  APIManager.swift
//  YoutubeDemo
//
//  Created by Giresh Dora on 12/10/18.
//  Copyright © 2018 Giresh Dora. All rights reserved.
//

import Foundation
import UIKit

let API_KEY = "YOUR_API_KEY"

class APIManager {
    
    static let sharedInstance = APIManager()
    
    typealias CompletionHandler = (_ success: VideoDetailsList?,_ error: String?)->()
    
    func getVideoList(str:String,complitionHandler:@escaping CompletionHandler){
        
        let contryCode = self.getCountryCode()
        let strURL = str+"&regionCode=\(contryCode)&key=\(API_KEY)"
        
        guard let url = URL(string: strURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if error != nil {
                complitionHandler(nil, "Please check your network connection.")
            }
            
            guard let data = data else { return }
            do{
                let videoDetailList = try JSONDecoder().decode(VideoDetailsList.self, from: data)
                complitionHandler(videoDetailList,nil)
            }catch{
                
            }
        }.resume()
    }
    
    //MARK: Get Country code
   fileprivate func getCountryCode() -> String {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            return countryCode
        }
        return ""
    }
}
