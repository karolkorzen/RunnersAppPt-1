//
//  CompetitionsService.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 01/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Firebase

struct CompetitionsService {
    static let shared = CompetitionsService()
    
    func addCompetition() {
        
    }
    
    func fetchCompetition(withCompetitionHeaderModel header: CompetitionHeaderModel, withUsers invited: [String], completion: @escaping(() -> Void)) {
        
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let values = ["name" : header.title,
                      "timestampStart" : header.startDate.timeIntervalSince1970,
                      "timestampStop" : header.stopDate.timeIntervalSince1970,
                      "owner" : currentUID,
                      "distance" : header.distance,
        ] as [String : Any]
        let ref = REF_COMPETITIONS.childByAutoId()
        ref.updateChildValues(values)
        ref.child("competitors").child(currentUID)
        let ref_inv = ref.child("invited")
        for index in invited {
            ref_inv.updateChildValues(["\(index)" : "1"])
        }
    }
    
    func deleteCompetition() {
        
    }
    
    func inviteToCompetition() {
        
    }
    
    func deleteFromCompetition() {
        
    }
    
}
