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
    typealias trainingsList = [String: [Location]]
    typealias dateTrainingList = [String: trainingsList]
    
    
    
    func uploadRunSession(withRunSession runTable: [Location] ) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let monthYear = monthYearTimestamp(withDate: runTable[0].timestamp)
        
        let ref = REF_USER_RUNS.child(currentUid).child(monthYear).childByAutoId()
        for index in runTable {
            let ref_num = ref.child("\(index.readNumber)")
            ref_num.updateChildValues(["latitude" : index.latitude])
            ref_num.updateChildValues(["longitude" : index.longitude])
            ref_num.updateChildValues(["speed" : index.speed])
            ref_num.updateChildValues(["altitude" : index.altitude])
            ref_num.updateChildValues(["timestamp" : index.timestamp.timeIntervalSince1970])
            ref_num.updateChildValues(["course" : index.course])
        }
    }
    
    private func monthYearTimestamp (withDate date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "MMMM yyyy"
        return format.string(from: date)
    }
    
//    func fetchRunningSessions(completion : @escaping( (dateTrainingList) -> Void)) {
//        var dict = dateTrainingList()
//        guard let currentUid = Auth.auth().currentUser?.uid else {return}
//        let db_ref = REF_USER_RUNS.child(currentUid)
//        REF_USER_RUNS.child(currentUid).child(currentUid).observe(.childAdded) { (dateMonthDict) in
//            print("111111111")
//            print("DATEMONTJ : \(dateMonthDict)")
//            let dateMonth = dateMonthDict.key
//            print("111111111")
//            print("DATEMONTJ : \(dateMonthDict)")
//            let ref2 = db_ref.child(currentUid).child(dateMonth)
//
//            ref2.observe(.childAdded) { (snapshot) in
//                print("222222222")
//                guard let trainingValues = snapshot.value as? NSArray else {return}
//                print("33333333")
//                var dict1 = trainingsList ()
//                let trainingUid = snapshot.key
//                let training = createTrainingFromDictionary(withNSArray: trainingValues)
//
//                dict1[trainingUid] = training
//                dict[dateMonth] = dict1
//                print("DEBUG: dict -> \(dict)")
//                completion(dict)
//            }
//        }
//    }
    
    func fetchRuns(completion: @escaping((dateTrainingList) -> Void)) {
        var dictionary = dateTrainingList()
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_RUNS.child(currentUID).observe(.childAdded) { (snapshot) in
            let monthYear = snapshot.key
            let trainings = snapshot.value as! [String : AnyObject]
            var tmp = trainingsList()
            for (index, value) in trainings.enumerated() {
                let trainingID = Array(trainings)[index].key
                let array = Array(trainings)[index].value
                tmp[trainingID]  = createTrainingFromDictionary(withArray: array as! Array<Any>)
                dictionary[monthYear] = tmp
                completion(dictionary)
            }
//            REF_USER_RUNS.child(currentUID).observe(snapshot) { (snapshot) in
//                let postID = snapshot.key
//
//                self.fetchPost(forPostID: postID) { (post) in
//                    posts.append(post)
//                    completion(posts)
//                }
//            }
        }
    }
    
//    func fetchRunningSessions(completion : @escaping( (trainingsList) -> Void)) {
//        var dict = trainingsList()
//        guard let currentUid = Auth.auth().currentUser?.uid else {return}
//        let ref = REF_USER_RUNS.child(currentUid)
//        ref.observe(.childAdded) { (snapshot) in
//            guard let trainingValues = snapshot.value as? NSArray else {return}
//
//            let trainingUid = snapshot.key
//            let training = createTrainingFromDictionary(withNSArray: trainingValues)
//
//            dict[trainingUid] = training
//            completion(dict)
//        }
//    }
//
    private func createTrainingFromDictionary(withArray array: Array<Any>) -> [Location] {
        var training = [Location]()
        for (index, value) in array.enumerated() {
            let value = value as! Dictionary<String, Any>
            let loc = Location(readNumber: index, altitude: value["altitude"] as! Double, course: value["course"] as! Double, longitude: value["longitude"] as! Double, latitude: value["latitude"] as! Double, speed: value["speed"] as! Double, timestamp: value["timestamp"] as! Double)
            training.append(loc)
        }
        return training
    }
    
}

