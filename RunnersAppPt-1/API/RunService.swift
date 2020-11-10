//
//  RunService.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 03/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Firebase

struct RunService {
    static let shared = RunService()
    
    func uploadRunSession(withRunSession runTable: [Location] ) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let ref = REF_USER_RUNS.child(currentUid).childByAutoId()
        for index in runTable {
            let ref_num = ref.child("\(index.readNumber)")
            ref_num.updateChildValues(["latitude" : index.latitude])
            ref_num.updateChildValues(["longitude" : index.longitude])
            ref_num.updateChildValues(["speed" : index.speed])
            ref_num.updateChildValues(["altitude" : index.altitude])
            if let floor = index.floor {
                ref_num.updateChildValues(["floor" : floor])
            }
            ref_num.updateChildValues(["timestamp" : index.timestamp.timeIntervalSince1970])
            ref_num.updateChildValues(["course" : index.course])
        }
    }
    
    func fetchRunningSessions(completion : @escaping( ([[Location]]) -> Void)) {
        var array = [[Location]]()
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let ref = REF_USER_RUNS.child(currentUid)
        ref.observe(.childAdded) { (snapshot) in
            let trainingUid = snapshot.key
            guard let trainingValues = snapshot.value as? NSArray else {return}
            createTrainingFromDictionary(withDictionary: trainingValues)
            
//            print("DEBUG: \(uid)")
//            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            //array.append()
        }
    }
    
    func createTrainingFromDictionary(withDictionary dictionary: NSArray) {
        for index in dictionary {
            print("\(index)")
        }

    }
}

