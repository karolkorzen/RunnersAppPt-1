//
//  UploadPostViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 18/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

enum UploadPostConfiguration {
    case post
    case reply(Post)
    case postTraining
}

struct UploadPostViewModel{

    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadPostConfiguration){
        switch config{
        case .post:
            actionButtonTitle = "Post"
            placeholderText = "How's your training going?"
            shouldShowReplyLabel = false
        case.reply(let post):
            actionButtonTitle = "Reply"
            placeholderText = "Post your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(post.user.username)"
        case .postTraining:
            actionButtonTitle = "Post"
            placeholderText = "How's your training going?"
            shouldShowReplyLabel = false
        }
    }
    
}
