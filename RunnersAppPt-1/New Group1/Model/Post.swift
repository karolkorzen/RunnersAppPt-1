//
//  Post.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 12/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation
 
struct Post{
    let postID: String
    let caption: String
    var likes: Int
    var timestamp: Date!
    let repostCount: Int
    var user: User
    var didLike = false
    var replyingTo: String?
    
    var isReply: Bool {return replyingTo != nil}
    
    init(user: User, postID: String, dictionary: [String: Any]) {
        self.postID = postID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        if let timestamp = dictionary["timestamp"] as? Double{
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        if let replyingTo = dictionary["replyingTo"] as? String{
            self.replyingTo = replyingTo
        }
        self.repostCount = dictionary["retweet"] as? Int ?? 0
    }
}
