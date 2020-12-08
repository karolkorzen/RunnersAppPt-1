//
//  StatsViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 15/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

protocol StatsSummaryViewModelDelegate: class {
    func handleUpdate()
}

class StatsSummaryViewModel {
    weak var delegate: StatsSummaryViewModelDelegate?
    
    var goal: Double = 0.0
    
    var statsArray: [Stats] = [] {
        didSet {
            self.statsSummary = self.computeStats()
        }
    }
    var statsSummary: StatsSummary = StatsSummary()
    
    func fetchStats() {
        RunService.shared.fetchStats { (array) in
            self.statsArray = array
        }
    }
    
    func fetchGoal() {
        GoalService.shared.fetchGoal { (goal) in
            self.goal = goal
        }
    }
    
    init(){
        fetchGoal()
        fetchStats()
    }

    var avgRunTimeLabelText: String {
        return "average running time:\n\(Int(statsSummary.avgRunTime/60)) minutes"
    }
    
    var maxRunTimeLabelText: String {
        return "maximum running time:\n\(Int(statsSummary.maxRunTime/60)) minutes"
    }
    
    var avgDistanceLabelText: String {
        return "average distance:\n\(Int(statsSummary.avgDistance)) metres"
    }
    
    var maxDistanceLabelText: String {
        return "maximum distance:\n\(Int(statsSummary.maxDistance)) metres"
    }
    
    var avgSpeedLabelText: String {
        return "average speed:\n\(round(statsSummary.avgSpeed*3.6*10)/10) km/h"
    }
    
    var maxSpeedLabelText: String {
        return "max speed:\n\(round(statsSummary.maxSpeed*3.6*10)/10) km/h"
    }
    
    
    func computeStats() -> StatsSummary {
        var avgRunTime: Double = 0.0
        var altitudeMax: Double = -Double.greatestFiniteMagnitude
        var altitudeMin: Double = Double.greatestFiniteMagnitude
        var avgSpeed: Double = 0.0
        var distance: Double = 0.0
        var avgDistance: Double = 0.0
        var maxDistance: Double = 0.0
        var maxSpeed: Double = 0.0
        var maxRunTime: Double = 0.0
        for value in statsArray {
            avgRunTime += value.time
            if (value.altitudeMax > altitudeMax) {
                altitudeMax = value.altitudeMax
            }
            if (value.altitudeMin < altitudeMin) {
                altitudeMin = value.altitudeMin
            }
            avgSpeed += value.avgSpeed
            distance += value.distance
            if (value.maxSpeed > maxSpeed) {
                maxSpeed = value.maxSpeed
            }
            if (value.time > maxRunTime) {
                maxRunTime = value.time
            }
            avgDistance += distance
            if (value.distance > maxDistance) {
                maxDistance = value.distance
            }
        }
        
        avgRunTime = avgRunTime / Double(statsArray.count)
        avgSpeed = avgSpeed / Double(statsArray.count)
        avgDistance = avgDistance / Double(statsArray.count)
        
        return StatsSummary(averageRunTime: avgRunTime, maxRunTime: maxRunTime, wholeDistance: distance, avgDistance: avgDistance, maxDistance: maxDistance, avgSpeed: avgSpeed, maxSpeed: maxSpeed, altitudeMin: altitudeMin, altitudeMax: altitudeMax)
    }
}
