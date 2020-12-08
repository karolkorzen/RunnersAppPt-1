//
//  CompetitionModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 05/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation
import Firebase

class Competition {
    let id: String
    let title: String
    let distance: Double
    let startDate: Date
    let stopDate: Date
    var competitors: [User]
    
    init() {
        self.id = ""
        self.title = ""
        self.distance = 0.0
        self.startDate = Date()
        self.stopDate = Date()
        self.competitors = []
    }
    
    init(withID id: String, withTitle title: String, withDistance distance: Double, withStartDate startDate: Date, withStopDate stopDate: Date, withCompetitors competitors: [User] = []){
        self.id = id
        self.title = title
        self.distance = distance
        self.startDate = startDate
        self.stopDate = stopDate
        self.competitors = competitors
    }
    
    init(withID id: String, withTitle title: String, withDistance distance: Double, withStartDate startDate: Date, withStopDate stopDate: Date, withUIDS uids: [String]){
        self.id = id
        self.title = title
        self.distance = distance
        self.startDate = startDate
        self.stopDate = stopDate
        self.competitors = []
        fetch(withUIDS: uids)
    }
    
    func fetch(withUIDS uids: [String]){
        fetchUsers(withUIDS: uids) { (array) in
            self.competitors=array
        }
    }
    
    func fetchUsers(withUIDS uids: [String], completion: @escaping(([User]) -> Void)) {
        var users:[User] = []
        for value in uids {
            REF_USERS.child(value).observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
                let user = User(uid: value, dictionary: dictionary)
                users.append(user)
                completion(users)
            }
        }
    }
}
