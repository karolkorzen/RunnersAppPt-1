//
//  StatsViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 15/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

class StatsSummaryViewModel {
    var statsArray: [Stats] = []
    var statsSummary: StatsSummary = StatsSummary()
    
    init(){
        RunService.shared.fetchStats { (array) in
            self.statsArray = array
            self.statsSummary = self.computeStats()
        }
    }
    
    var testLabel: String {
        return "max dist = \(statsSummary.maxDistance)"
    }
    
    private func computeStats() -> StatsSummary {
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
