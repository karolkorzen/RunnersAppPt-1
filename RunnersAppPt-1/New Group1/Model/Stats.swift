//
//  Stats.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 13/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

struct Stats {
    let time: Double
    let timestampStart: Double
    let timestampStop: Double
    let distance: Double
    let avgSpeed: Double
    let maxSpeed: Double
    let altitudeMin: Double
    let altitudeMax: Double
    
    var training: [Location]? = nil
    
    init () {
        self.time = 0.0
        self.timestampStart = 0.0
        self.timestampStop = 0.0
        self.distance = 0.0
        self.avgSpeed = 0.0
        self.maxSpeed = 0.0
        self.altitudeMin = 0.0
        self.altitudeMax = 0.0
        self.training = []
    }
    
    init(time: Double, timestampStart: Double, timestampStop: Double, distance: Double, avgSpeed: Double, maxSpeed: Double, altitudeMin: Double, altitudeMax: Double, training: [Location]){
        self.time = time
        self.timestampStart = timestampStart
        self.timestampStop = timestampStop
        self.distance = distance
        self.avgSpeed = avgSpeed
        self.maxSpeed = maxSpeed
        self.altitudeMin = altitudeMin
        self.altitudeMax = altitudeMax
        self.training = training
    }
    
    init(time: Double, timestampStart: Double, timestampStop: Double, distance: Double, avgSpeed: Double, maxSpeed: Double, altitudeMin: Double, altitudeMax: Double){
        self.time = time
        self.timestampStart = timestampStart
        self.timestampStop = timestampStop
        self.distance = distance
        self.avgSpeed = avgSpeed
        self.maxSpeed = maxSpeed
        self.altitudeMin = altitudeMin
        self.altitudeMax = altitudeMax
    }
}
