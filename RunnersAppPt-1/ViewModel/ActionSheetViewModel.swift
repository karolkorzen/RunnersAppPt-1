//
//  ActionSheetViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 20/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

struct ActionSheetViewModel {
    private let user: User
    
    var options: [ActionSheetOptions]{
        var results = [ActionSheetOptions]()
        if user.isCurrentUser{
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
            results.append(.report)
        }
        return results
    }
    
    init(user: User){
        self.user = user
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String{
        switch self{
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .report:
            return "Report Post"
        case .delete:
            return "Delete Post"
        }
    }
}
