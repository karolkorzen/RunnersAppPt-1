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
    
    func uploadRunSession(withRunSession runTable: [Location], completion: @escaping(()->Void) ) {
        print("DEBUG: uploading to firebase..")
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let ref = REF_USER_RUNS.child(currentUid).childByAutoId()
        for index in runTable {
            let ref_num = ref.child("\(index.number)")
            ref_num.updateChildValues(["latitude" : index.coordinate.coordinate.latitude])
            ref_num.updateChildValues(["longitude" : index.coordinate.coordinate.longitude])
            ref_num.updateChildValues(["speed" : index.coordinate.speed])
            ref_num.updateChildValues(["timestamp" : index.coordinate.timestamp.timeIntervalSince1970])
            //REF_USER_RUNS.child(currentUid).ID_RUN.runTable.updateChildValues([AnyHashable : Any])
        }
        completion()
    }
}

