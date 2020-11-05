//
//  NotificationService.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 22/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, post: Post? = nil, user: User? = nil) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if (uid == post?.user.uid) || (uid == user?.uid) {
            return
        }
        
        var values: [String : Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                      "uid" : uid,
                                      "type" : type.rawValue]
        
        if let post = post {
            values["postID"] = post.postID
            REF_NOTIFICATIONS.child(post.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
        }
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String : AnyObject] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}
