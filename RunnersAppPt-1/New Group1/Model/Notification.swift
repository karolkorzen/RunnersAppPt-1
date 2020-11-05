//
//  Notification.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 22/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case repost
    case mention
}

struct Notification {
    let postID: String?
    let timestamp: Date!
    var user: User
    var post: Post?
    var type: NotificationType
    
    init(user: User, post: Post? = nil, dictionary: [String : AnyObject]) {
        self.user = user
        self.post = post
        
        self.postID = dictionary["postID"] as? String
        
        self.timestamp = Date(timeIntervalSince1970: dictionary["timestamp"] as! Double)
        
        self.type = NotificationType(rawValue: dictionary["type"] as! Int)!
    }
}
