//
//  PostController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 16/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

private let reuseIdentifier = "postidentfier"
private let headerIdentifier = "headeridentifier"

class PostController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let post: Post
    private var actionSheetLauncher: ActionSheetLauncher!
    private var replies = [Post]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    init(post: Post){
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchReplies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: - API
    
    func fetchReplies(){
        PostService.shared.fetchReplies(forPost: post) { (replies) in
            self.replies = replies
        }
        
    }
    
    //MARK: - Helpers
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        //FIXME : - content acjusting = collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(PostHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate=self
        actionSheetLauncher.show()
    }
}
// MARK: - UICollectionViewDataSource

extension PostController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        cell.post = replies[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension PostController{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! PostHeader
        header.post = post
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PostController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = PostViewModel(post: post)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

//MARK: - PostHeaderDelegate

extension PostController: PostHeaderDelegate{
    func handleFetchUser(withUserName username: String) {
        UserService.shared.fetchUser(withUsername: username) { (user) in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func showActionSheet() {
        if post.user.isCurrentUser {
            showActionSheet(forUser: post.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: post.user.uid) { (isFollowed) in
                var user = self.post.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
    }
}

//MARK: - ActionSheetLauncherDelegate

extension PostController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        print("Option in Post Controller is \(option.description)")
        switch option{
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                //FIXME: GIMME ANIMATION OR SMTH
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                //FIXME: GIMME ANIMATION OR SMTH
            }
        case .report:
            //FIXME : REPORT
            print("report")
        case .delete:
            print("delete")
            //FIXME - POPUP
            PostService.shared.deletePost(forPost: post)
            print("deleted xddd")
        }
    }
}
