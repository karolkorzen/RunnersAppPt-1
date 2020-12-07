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
    typealias TrainingsList = [String: Stats]
    
    /// func uploads run session after reading from [Location] runTable
    /// - Parameter runTable: [Location]
    func uploadRunSession(withRunSession runTable: [Location] , withStats stats: Stats) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        let values = ["time" : stats.time,
                      "distance": stats.distance,
                      "timestampStart" : stats.timestampStart,
                      "timestampStop" : stats.timestampStop,
                      "avgSpeed" : stats.avgSpeed,
                      "maxSpeed" : stats.maxSpeed,
                      "altitudeMin" : Double(stats.altitudeMin.description),
                      "altitudeMax" : Double(stats.altitudeMin.description)
        ] as [String : Any]
        
        var ref = REF_USER_RUNS.child(currentUid).childByAutoId()
        ref.updateChildValues(values)
        ref = ref.child("locations")
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
    
    /// func fetches runs for curr user from firebase
    /// - Parameter completion: dateTrainingsList
    func fetchRuns(completion: @escaping((TrainingsList) -> Void)) {
        var dictionary = TrainingsList()
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        REF_USER_RUNS.child(currentUID).observe(.childAdded) { (snapshot) in
            let trainingID = snapshot.key
            let training = snapshot.value as! [String : AnyObject]
            let stats = createStatsFromDictionary(training: training)
            dictionary[trainingID] = stats
            completion(dictionary)
        }
    }
    
    func deleteRun(withTrainingID id: String, completion: @escaping(()->Void)) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_RUNS.child(currentUID).child(id).removeValue { (error, ref) in
            completion()
        }
    }
    
    /// func fetches stats from runs
    /// - Parameter completion: [Stats]
    func fetchStats(completion: @escaping([Stats]) -> Void) {
        var statsArray: [Stats] = []
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_RUNS.child(currentUID).observe(.childAdded) { (snapshot) in
            print("DEBBUG: \(snapshot.value)")
            let tRaining = snapshot.value as! [String : AnyObject]
            print("DEBBUG: training!!! \(tRaining)")
            let stats = createStatsFromDictionary(training: tRaining)
            statsArray.append(stats)
            completion(statsArray)
        }
    }
    
    func fetchStatsForUser(withUID uid: String, completion: @escaping([Stats]) -> Void) {
        var statsArray: [Stats] = []
        let currentUID = uid
        
        REF_USER_RUNS.child(currentUID).observe(.childAdded) { (snapshot) in
            print("DEBBUG: \(snapshot.value)")
            let tRaining = snapshot.value as! [String : AnyObject]
            print("DEBBUG: training!!! \(tRaining)")
            let stats = createStatsFromDictionary(training: tRaining)
            statsArray.append(stats)
            completion(statsArray)
        }
    }
    
    func checkIfRunsAreEmpty(completion: @escaping((Bool) -> Void)){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_RUNS.child(currentUID).observe(.childAdded) { (snapshot) in
            if (snapshot.exists()){
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    
    /// func creates Stats object from training dictionary
    /// - Parameter training: dictionary containing training stats with locations
    /// - Returns: Stats
    func createStatsFromDictionary(training: [String : AnyObject]) -> Stats {
        let trainingLocations = createTrainingFromDictionary(withArray: training["locations"] as? Array<Any> ?? Array())
        let time = training["time"] as? Double ?? 0.0
        let timestampStart = training["timestampStart"] as? Double ?? 0.0
        let timestampStop = training["timestampStop"] as? Double ?? 0.0
        let distance = training["distance"] as? Double ?? 0.0
        let avgSpeed = training["avgSpeed"] as? Double ?? 0.0
        let maxSpeed = training["maxSpeed"] as? Double ?? 0.0
        let altitudeMin = training["altitudeMin"] as? Double ?? 0.0
        let altitudeMax = training["altitudeMax"] as? Double ?? 0.0
        
        let ret = Stats(time: time, timestampStart: timestampStart, timestampStop: timestampStop, distance: distance, avgSpeed: avgSpeed, maxSpeed: maxSpeed, altitudeMin: altitudeMin, altitudeMax: altitudeMax, training: trainingLocations)

        return ret
    }
    
    /// func creates Training from dictionary
    /// - Parameter array: trainings
    /// - Returns: array [Location] filled with locations
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

