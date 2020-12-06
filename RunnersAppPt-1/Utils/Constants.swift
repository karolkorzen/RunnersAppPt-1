//
//  Constants.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 10/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_POSTS = DB_REF.child("posts")
let REF_USER_POSTS = DB_REF.child("user-posts")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_POST_REPLIES = DB_REF.child("post-replies")
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_POST_LIKES = DB_REF.child("post-likes")
let REF_NOTIFICATIONS = DB_REF.child("notifications")
let REF_USER_REPLIES = DB_REF.child("user-replies")
let REF_USER_USERNAMES = DB_REF.child("user-usernames")
let REF_USER_RUNS = DB_REF.child("user-runs")
let REF_USER_GOAL = DB_REF.child("user-goal")
let REF_COMPETITIONS = DB_REF.child("competitions")
let REF_USER_INVITE = DB_REF.child("user-invite")
let REF_USER_COMPETITIONS = DB_REF.child("user-competitions")
