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
    
    private var actionButton = Utilities.shared.actionButton(withSystemName: "pencil.and.outline")
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = .mainAppColor
        view.tintColor = .mainAppColor
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
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 45, height: 45)
        actionButton.layer.cornerRadius = 10
        
        view.backgroundColor = .mainAppColor
        view.tintColor = .mainAppColor
    }
    
    func configureViewControllers(){
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(systemName: "house.fill")!, rootViewController: feed)
        
        let run = RunController(tabBarHeight: self.tabBar.frame.size.height)
        let navR = templateNavigationController(image: UIImage(systemName: "hare.fill")!, rootViewController: run)
        
        let stats = StatsController()
        let navS = templateNavigationController(image: UIImage(systemName: "chart.pie.fill")!, rootViewController: stats)
    
        let notifications = NotificationsController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav3 = templateNavigationController(image: UIImage(systemName: "lightbulb.fill")!, rootViewController: notifications)
        
        let conversations = ConversationsController()
        let nav4 = templateNavigationController(image: UIImage(systemName: "envelope.fill")!, rootViewController: conversations)
        
        viewControllers = [nav1, navS, navR, nav3, nav4]
    }

    func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        return nav
    }

}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 0 || index == 4 {
            self.actionButton.isHidden=false
            let imageName = index == 4 ? "message.fill" : "pencil.and.outline"
            self.actionButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .default)), for: .normal)
            buttonConfig = index == 4 ? .message : .post
            //FIXME: - fix size
        } else {
            self.actionButton.isHidden=true
        }
    }
}
