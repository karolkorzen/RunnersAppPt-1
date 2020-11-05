//
//  NotificationViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 22/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

struct NotificationViewModel{
    
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    
    var notificationMessage: String{
        switch type {
            
        case .follow:
            return " started following you"
        case .like:
            return " liked your post"
        case .reply:
            return " replied to your post"
        case .repost:
            return " reposted your post"
        case .mention:
            return " mentioned you in a post "
        }
    }
    
    private var timestampString: String? {  //FIXME: - MAKE IT DYNAMIC
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "0s"
    }
    
    var notificationText: NSAttributedString? {
        let timestamp = timestampString!
        let attributedText = NSMutableAttributedString(string: "@"+user.username, attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage, attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonText: String{
        return user.isFollowed ? "Following" : "Follow"
    }
    
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
