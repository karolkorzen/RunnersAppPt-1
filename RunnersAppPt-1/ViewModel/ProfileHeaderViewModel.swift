//
//  ProfileHeaderViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 15/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case posts
    case replies
    case likes
    
    var desciption: String {
        switch self {
        case .posts: return "Posts"
        case .replies: return "Posts and Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: " followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: " following")
    }
    
    var actionButtonTitle: String {
        if !user.isCurrentUser {
            if !user.isFollowed {
                return "Follow"
            } else {
                return "Following"
            }
        } else {
            return "Edit Profile"
        }
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
