//
//  MainTabController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 29/09/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import Firebase

enum ActionButtonConfiguration {
    case post
    case message
    case run
}

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .post
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            
            feed.user = user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .bluish
        let runIconConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .default)
        let img = UIImage(systemName: "text.badge.plus", withConfiguration: runIconConfig)
        button.setImage(img, for: .normal)
        
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bluish
        authenticateUserAndConfigureUI()
    }
    
    // MARK: -API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { (user) in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonTapped(){
        switch buttonConfig {
        case .post:
            guard let user = user else {return}
            let controller = UploadPostController(user: user, config: .post)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .message:
            let controller = NewMessageController()
            let nav = UINavigationController(rootViewController: controller)
            present(nav, animated: true, completion: nil)
        case .run:
            break
        }

    }

    // MARK: - Helpers

    func configureUI(){
        self.delegate = self
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 45, height: 45)
        actionButton.layer.cornerRadius = 10
    }
    
    func configureViewControllers(){
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected")!, rootViewController: feed)
        
        let explore = SearchController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected")!, rootViewController: explore)
        
        let run = RunController(tabBarHeight: self.tabBar.frame.size.height)
        let navR = templateNavigationController(image: UIImage(named: "like_unselected")!, rootViewController: run)
        
        let stats = StatsController(collectionViewLayout: UICollectionViewFlowLayout())
        let navS = templateNavigationController(image: UIImage(named: "like_unselected")!, rootViewController: stats)
    
        let notifications = NotificationsController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected")!, rootViewController: notifications)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1")!, rootViewController: conversations)
        
        viewControllers = [nav1, nav2, navR, navS, nav3, nav4]
    }

    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = UIColor.systemBackground
        return nav
    }

}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 || index == 3 {
            self.actionButton.isHidden=true
        } else {
            self.actionButton.isHidden=false
            let imageName = index == 5 ? "mail" : "text.badge.plus"
            self.actionButton.setImage(UIImage(systemName: imageName), for: .normal)
            buttonConfig = index == 5 ? .message : .post
            //FIXME: - fix size
        }
    }
}
