//
//  PostViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 13/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

struct PostViewModel {
    
    //MARK: - Properties
    
    let post: Post
    let user: User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var timestamp: String {  //FIXME: - MAKE IT DYNAMIC
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: post.timestamp, to: now) ?? "0s"
    }
    
    var usernameText: String{
        return "@\(user.username)"
    }
    
    var headerTimestamp: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • dd/MM/yyyy"
        return formatter.string(from: post.timestamp)
    }
    
    var repostAttributedString: NSAttributedString {
        return attributedText(withValue: post.repostCount, text: " Reposts")
    }
    
    var likesAttributedString: NSAttributedString {
        return attributedText(withValue: post.likes, text: " Likes")
    }

    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " • \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .mainAppColor : .darkGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = post.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var shouldHideReplyLabel: Bool{
        return !post.isReply
    }
    
    var replyText: String?{
        guard let replyingToUsername = post.replyingTo else {return nil}
        return "→Replying to @\(replyingToUsername)"
    }
    
    //MARK: - Lifecycle
    
    init(post: Post) {
        self.post = post
        self.user = post.user
    }
    
    //MARK: - Helpers
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = post.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
