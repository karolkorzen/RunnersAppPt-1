//
//  StatsSummary.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 17/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

struct StatsSummary {
    
    let avgRunTime: Double
    let maxRunTime: Double
    let wholeDistance: Double
    let avgDistance: Double
    let maxDistance: Double
    let avgSpeed: Double
    let maxSpeed: Double
    let altitudeMin: Double
    let altitudeMax: Double
    
    init () {
        self.avgRunTime = 0.0
        self.maxRunTime = 0.0
        self.wholeDistance = 0.0
        self.avgDistance = 0.0
        self.maxDistance = 0.0
        self.avgSpeed = 0.0
        self.maxSpeed = 0.0
        self.altitudeMin = 0.0
        self.altitudeMax = 0.0
    }
    
    init(averageRunTime: Double, maxRunTime: Double, wholeDistance: Double, avgDistance: Double, maxDistance: Double, avgSpeed: Double, maxSpeed: Double, altitudeMin: Double, altitudeMax: Double) {
        self.avgRunTime = averageRunTime
        self.maxRunTime = maxRunTime
        self.wholeDistance = wholeDistance
        self.avgDistance = avgDistance
        self.maxDistance = maxDistance
        self.avgSpeed = avgSpeed
        self.maxSpeed = maxSpeed
        self.altitudeMin = altitudeMin
        self.altitudeMax = altitudeMax
    }
}
