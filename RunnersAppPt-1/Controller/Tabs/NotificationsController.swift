//
//  NotificationsController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 08/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

private let reuseIdentifier = "notificationcell"

class NotificationsController: UICollectionViewController {
    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        for (_, cell) in collectionView.visibleCells.enumerated(){
            self.reloadFollowButton(cell as! NotificationCell)
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleRefresh() {
        refreshControl.beginRefreshing()
        fetchNotifications()
        Utilities.shared.dispatchDelay(delay: 1) {
            self.refreshControl.endRefreshing()
        }
    }

    // MARK: - API
    
    func fetchNotifications() {
        NotificationService.shared.fetchNotifications { (notifications) in
            self.notifications = notifications
            self.checkIfUserIsFollowed(notifications: notifications)
        }
    }
    
    func checkIfUserIsFollowed(notifications: [Notification]) {
        for(index, notification) in notifications.enumerated() {
            if notification.type == .follow {
                UserService.shared.checkIfUserIsFollowed(uid: notification.user.uid) { (isFollowed) in
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
    // MARK: - Helpers

    func configureUI(){
        view.backgroundColor = .white
        
        collectionView.register(NotificationCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        navigationItem.title = "Notifications"
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func reloadFollowButton(_ cell: NotificationCell){
        guard let uid = cell.notification?.user.uid else {return}
        UserService.shared.checkIfUserIsFollowed(uid: uid, completion: { (isFollowed) in
            if isFollowed {
                cell.notification?.user.isFollowed = true
            } else {
                cell.notification?.user.isFollowed = false
            }
        })
    }
}

//MARK: - UITableViewDataSource

extension NotificationsController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.delegate = self
        cell.notification = notifications[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // FIXME : - API CALL
        if  notifications[indexPath.row].type == .follow {
            let user = notifications[indexPath.row].user
            self.navigationController?.pushViewController(ProfileController(user: user), animated: true)
        } else  {
            guard let postID = notifications[indexPath.row].postID else {return}
            PostService.shared.fetchPost(forPostID: postID) { (post) in
                self.navigationController?.pushViewController(PostController(post: post), animated: true)
            }
        }
        //
 
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NotificationsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}

//MARK: - DELEGATE

extension NotificationsController: NotificationCellDelegate {
    
    
    func didTapFollow(_ cell: NotificationCell) {
        
        guard let isFollowed = cell.notification?.user.isFollowed else {return}
        guard let uid = cell.notification?.user.uid else {return}
        
        if isFollowed {
            UserService.shared.unfollowUser(uid: uid) { (error, ref) in
                cell.notification?.user.isFollowed = false
                
            }
        } else {
            UserService.shared.followUser(uid: uid) { (error, ref) in
                cell.notification?.user.isFollowed = true
                NotificationService.shared.uploadNotification(type: .follow, user: cell.notification?.user)
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
