//
//  StatsService.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 22/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Firebase

struct GoalService {
    static let shared = GoalService()
    
    func uploadGoal(withGoal goal: Double, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = REF_USER_GOAL.child(uid)
        ref.updateChildValues(["distance" : goal]) {_,_ in
            completion()
        }
    }
    
    func fetchGoal(completion: @escaping(Double) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = REF_USER_GOAL.child(uid)
        ref.observeSingleEvent(of: .childAdded) { (snapshot, string) in
            print("DEBUG: in fetch goal -> \(snapshot.value)")
            completion(snapshot.value as! Double)
        }
    }
}
