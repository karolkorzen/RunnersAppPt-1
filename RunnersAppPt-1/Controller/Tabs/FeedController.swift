//
//  FeedController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 08/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Post cell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.fetchPosts()
            self.collectionView.reloadData()
        }
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - SELECTORS
    
    @objc func handleRefresh(){
        fetchPosts() //doesnt work!!!
    }
    
    @objc func takeToMyProfile(){
        guard let user = user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func search(){
        let explore = SearchController()
        navigationController?.pushViewController(explore, animated: true)
    }
    
    // MARK: - API
    
    func fetchPosts(){
        collectionView.refreshControl?.beginRefreshing()
        PostService.shared.fetchPosts { posts in
            //FIXME: - Make it in fetch and
            //FIXME: - make it for other ones
            self.posts = posts.sorted(by: {$0.timestamp > $1.timestamp})
            //            self.posts = posts.sorted(by: { (post1, post2) -> Bool in
            //                return post1.timestamp > post2.timestamp
            //            })
            self.posts.forEach { (post) in
                PostService.shared.checkIfUserLikedPost(post) { (didLike) in
                    if didLike {
                        if let index = self.posts.firstIndex(where: { (postt) -> Bool in
                            postt.postID == post.postID
                        }) {
                            self.posts[index].didLike = true
                        }
                    }
                }
            }
        }
        collectionView.refreshControl?.endRefreshing()
    }

    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 30, height: 30)
        imageView.tintColor = .pinkish
        navigationItem.titleView = imageView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged) //for is cool
        collectionView.refreshControl = refreshControl
        
        configureRightBarButton()
    }
    
    func configureLeftBarButton() {
        guard let user = user else {return}
        let profileImageView = UIImageView()
        profileImageView.image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 10
        profileImageView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(takeToMyProfile))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    func configureRightBarButton(){
        let image = UIImageView(image: UIImage(named: "search_unselected")!)
        image.setDimensions(width: 25, height: 25)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(search))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: image)
        navigationItem.rightBarButtonItem?.tintColor = .pinkish
        
    }
    
    
}

// MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        cell.delegate = self
        cell.post = posts[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PostController(post: posts[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = PostViewModel(post: posts[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width-12, height: height + 100)
    }
}

// MARK: - PostCell Delegate

extension FeedController: PostCellDelegate {
    func handleFetchUser(withUserName username: String) {
        UserService.shared.fetchUser(withUsername: username) { (user) in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleLikeButtonTapped(_ cell: PostCell) {
        cell.post?.didLike.toggle()
        guard let post = cell.post else {return}
        PostService.shared.likePost(post: post) { (err, ref) in
            cell.post?.likes = post.didLike ? post.likes + 1 : post.likes - 1
            //FIXME: - POST HEADER IS NOT UPLOADING
            if post.didLike {
                NotificationService.shared.uploadNotification(type: .like, post: post)
            }
            
        }
    }
    
    func handleReplyButtonTapped(_ cell: PostCell) {
        guard let post = cell.post else {return}
        let controller = UploadPostController(user: post.user, config: .reply(post))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleProfileImageTapped(_ cell: PostCell) {
        guard let user = cell.post?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
 
