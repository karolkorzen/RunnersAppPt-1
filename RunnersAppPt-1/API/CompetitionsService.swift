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
    
    func fetchSingleCompetition(withCompetitionID compID: String, completion: @escaping(Competition) -> Void){
        REF_COMPETITIONS.child(compID).observeSingleEvent(of: .value) { (snapshot) in
            guard let id = snapshot.key as? String else {return}
            guard let dictionary = snapshot.value as? [String : AnyObject] else {return}
            guard let competitiorsArray = dictionary["competitors"] as? [String : String] else {return}
            print("DEBUG: competitiorsArray -> \(competitiorsArray)")
            var uids: [String] = []
            for (index, value) in competitiorsArray {
                uids.append(index)
            }
            guard let distance = dictionary["distance"] as? Double else {return}
            guard let name = dictionary["name"] as? String else {return}
//            guard let owner = dictionary["owner"] as? String else {return}
            guard let timestampStart = dictionary["timestampStart"] as? Double else {return}
            guard let timestampStop = dictionary["timestampStop"] as? Double else {return}
            let dateStart = Date(timeIntervalSince1970: timestampStart)
            let dateStop = Date(timeIntervalSince1970: timestampStop)
            let competition = Competition(withID: id, withTitle: name, withDistance: distance, withStartDate: dateStart, withStopDate: dateStop, withUIDS: uids)
            completion(competition)
        }
    }
    
    func fetchInvites(completion: @escaping(([Competition]) -> (Void))) {
        var competitions: [Competition] = []
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        REF_USER_INVITE.child(currentUID).observe(.childAdded) { (snapshot) in
            let competitionID = snapshot.key
            fetchSingleCompetition(withCompetitionID: competitionID) { (competition) in
                competitions.append(competition)
                completion(competitions)
            }
        }
        
    }
    
    func fetchCompetitions(completion: @escaping(([Competition]) -> (Void))) {
        var competitions: [Competition] = []
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        REF_USER_COMPETITIONS.child(currentUID).observe(.childAdded) { (snapshot) in
            let competitionID = snapshot.key
            fetchSingleCompetition(withCompetitionID: competitionID) { (competition) in
                competitions.append(competition)
                completion(competitions)
            }
        }
    }
    
    /// func adds competition to database
    /// - Parameters:
    ///   - header: values about competiton
    ///   - invited: array of on create invited users
    ///   - completion: completion escaping at using func
    func addCompetition(withCompetitionHeaderModel header: CompetitionHeader, withUsers invited: [String], completion: @escaping(() -> Void)) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let values = ["name" : header.title,
                      "timestampStart" : header.startDate.timeIntervalSince1970,
                      "timestampStop" : header.stopDate.timeIntervalSince1970,
                      "owner" : currentUID,
                      "distance" : header.distance,
        ] as [String : Any]
        let ref = REF_COMPETITIONS.childByAutoId()
        guard let refID = ref.key else { return  }
        ref.updateChildValues(values)
        ref.child("competitors").updateChildValues([currentUID : "1"])
        addUserCompetiton(withCompetitonID: refID, withUserID: currentUID, completion: {})
        let ref_inv = ref.child("invited")
        for index in invited {
            ref_inv.updateChildValues(["\(index)" : "1"])
            addUserInvited(withCompetitonID: refID, withUserID: index)
        }
    }
    
    /// func adds invitation to competiton for user
    /// - Parameters:
    ///   - compId: competitionID
    ///   - userID: userID
    func addUserInvited(withCompetitonID compId: String, withUserID userID: String) {
        REF_USER_INVITE.child(userID).updateChildValues([compId : "1"])
    }
    
    /// func delets invite to user about competition
    /// - Parameters:
    ///   - compId: competitionID
    ///   - userID: userID
    func deleteUserInvited(withCompetitonID compId: String, withUserID userID: String, completion: @escaping(()->Void)) {
        REF_USER_INVITE.child(userID).child(compId).removeValue { (erroe, ref) in
            completion()
        }
    }
    
    /// func adds user to competiton
    /// - Parameters:
    ///   - compID: competitonID
    ///   - userID: userID
    func addUserCompetiton(withCompetitonID compID: String, withUserID userID: String, completion: @escaping(()->Void)){
        deleteUserInvited(withCompetitonID: compID, withUserID: userID) {
            REF_USER_COMPETITIONS.child(userID).updateChildValues([compID : "1"]) { (errr, ref) in
                REF_COMPETITIONS.child(compID).child("competitors").updateChildValues([userID : "1"])
                completion()
            }
        }
        
    }
    
    /// func delets user from competiton
    /// - Parameters:
    ///   - compId: competition ID
    ///   - userID: user ID
    func deleteUserCompetition(withCompetitonID compId: String, withUserID userID: String) {
        REF_COMPETITIONS.child(compId).child("competitors").observeSingleEvent(of: .childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : AnyObject] else {return}
            guard let competitiorsArray = dictionary["competitors"] as? [String : String] else {return}
            
            if competitiorsArray.count <= 1 {
                deleteCompetition(withCompetitonID: compId)
            }
        })
        REF_USER_COMPETITIONS.child(userID).child(compId).removeValue()
    }
    
    /// func deletes whole competiton
    /// - Parameter compId: competitonID
    func deleteCompetition(withCompetitonID compId: String) {
        REF_COMPETITIONS.child(compId).removeValue()
    }
}
