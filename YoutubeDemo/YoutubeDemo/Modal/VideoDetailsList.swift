//
//  VideoDetailsList.swift
//  YoutubeDemo
//
//  Created by Giresh Dora on 12/10/18.
//  Copyright © 2018 Giresh Dora. All rights reserved.
//

import Foundation

struct VideoDetailsList:Decodable {
    let items : [Items]?
}

struct Items:Decodable {
    let snippet:Snippet?
}

struct Snippet:Decodable {
    let thumbnails:Thumbnails?
    let title:String?
    let channelTitle:String?
}

struct Thumbnails:Decodable {
    let medium:Medium?
}
struct Medium:Decodable {
    let url:String?
    
}
