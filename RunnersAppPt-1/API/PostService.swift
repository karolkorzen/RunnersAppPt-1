//
//  PostService.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 12/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Firebase

struct PostService{
    static let shared = PostService()
    
    func uploadPost(caption: String, type: UploadPostConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String : Any]
        
        switch type {
        case .post:
            REF_POSTS.childByAutoId().updateChildValues(values) { (error, ref) in
                guard let postID = ref.key else {return}
                REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
            }
        case.reply(let post):
            values["replyingTo"] = post.user.username
            REF_POST_REPLIES.child(post.postID).childByAutoId().updateChildValues(values) { (err, ref) in
                guard let replyKey = ref.key else {return}
                REF_USER_REPLIES.child(uid).updateChildValues([post.postID : replyKey], withCompletionBlock: completion)
            }
        }
        
    }
    
    func fetchPost(forPostID postID: String, completion: @escaping(Post) -> Void) {
        REF_POSTS.child(postID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            UserService.shared.fetchUser(uid: uid) { (user) in
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                completion(post)
            }
        }
    }
    
    func fetchLikes(forUser user: User, completion: @escaping([Post]) -> Void){
        var posts = [Post]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            self.fetchPost(forPostID: snapshot.key) { (snapshotPost) in
                var post = snapshotPost
                post.didLike = true
                
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    /// function fetch posts of people that user follows
    /// - Parameter completion: completion on callers site
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUID).observe(.childAdded) { (snapshot) in
            let followingUid = snapshot.key
            
            REF_USER_POSTS.child(followingUid).observe(.childAdded) { (snapshot) in
                let postID = snapshot.key
                
                self.fetchPost(forPostID: postID) { (post) in
                    posts.append(post)
                    posts = posts.sorted(by: {$0.timestamp > $1.timestamp})
                    completion(posts)
                }
            }
        }
        REF_USER_POSTS.child(currentUID).observe(.childAdded) { (snapshot) in
            let postID = snapshot.key
            
            self.fetchPost(forPostID: postID) { (post) in
                posts.append(post)
                posts = posts.sorted(by: {$0.timestamp > $1.timestamp})
                completion(posts)
            }
        }
    }
    
    func fetchPosts(forUser user: User, completion: @escaping([Post]) -> Void){
        var posts = [Post]()
        REF_USER_POSTS.child(user.uid).observe(.childAdded) { (snapshot) in
            let postID = snapshot.key
            REF_POSTS.child(postID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                guard let uid = dictionary["uid"] as? String else {return}
                UserService.shared.fetchUser(uid: uid) { user in
                    let post = Post(user: user, postID: postID, dictionary: dictionary)
                    posts.append(post)
                    completion(posts)
                }
            }
        }
    }
    
    func fetchReplies(forUser user: User, completion: @escaping([Post]) -> Void){
        var replies = [Post]()
        
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { (snapshot) in
            let postKey = snapshot.key
            guard let replyKey = snapshot.value as? String else {return}
            
            REF_POST_REPLIES.child(postKey).child(replyKey).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
                guard let uid = dictionary["uid"] as? String else {return}
                let replyID = snapshot.key
                
                UserService.shared.fetchUser(uid: uid) { (user) in
                    let reply = Post(user: user, postID: replyID, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    func fetchReplies(forPost post: Post, completion: @escaping([Post])->Void) {
        var posts = [Post]()
        REF_POST_REPLIES.child(post.postID).observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(user: user, postID: snapshot.key, dictionary: dictionary)
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    func likePost(post: Post, completion: @escaping(DatabaseCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let likes = post.didLike ? post.likes + 1 : post.likes - 1
        REF_POSTS.child(post.postID).child("likes").setValue(likes)
        
        if post.didLike{
            //like
            REF_USER_LIKES.child(uid).updateChildValues([post.postID : 1]) { (err, ref) in
                REF_POST_LIKES.child(post.postID).updateChildValues([uid : 1], withCompletionBlock: completion)
            }
        } else {
            //unlike
            REF_USER_LIKES.child(uid).child(post.postID).removeValue { (err, ref) in
                REF_POST_LIKES.child(post.postID).child(uid).removeValue(completionBlock: completion)
            }
        }
        
    }
    
    func checkIfUserLikedPost(_ post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_LIKES.child(uid).child(post.postID).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    func deletePost(forPost post: Post){
        
        REF_POSTS.child(post.postID).removeValue()
    }
}
