//
//  RunViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 09/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import CoreLocation

class RunViewModel {
    
    func speedLabelText(withSpeed speed: Double) -> String{
        if speed > 0.0 {
            return "\(round(10*(speed*3.6))/10) km/h"
        }
        return "0 km/h"
    }
    
    func distanceLabelText(withDistance distance: Double) -> String {
        if distance>0.0 {
            if distance >= 1000 {
                return "\(round(distance)/1000) km"
            } else {
                return "\(round(distance)) m"
            }
        } else {
            return "0 m"
        }
    }
    func appendDistance(withCurrentDistance distance: Double, fromLocation location1: CLLocation, toLocation location2: CLLocation) -> Double {
        return distance + location1.distance(from: location2)
    }
    
    func appendRunTable(withTable table: [Location], withNewLocation location: CLLocation) -> [Location] {
        var tab = table
        tab.append(Location(withCLLoaction: location, withNumber: table.count))
        return tab
    }
    
    func retSpeedRounded (withSpeed speed: Double) -> Double{
        return round(speed*3.6)
    }
    
    func retRunTablesCLLocationCoordinates2D (withTable table: [Location]) -> [CLLocationCoordinate2D] {
        return table.map{$0.retCLLocationCoordinate2D()}
    }
    
    func createStats(runTable: [Location], distance: Double, time: Double) -> Stats {
        var max = 0.0
        var avg = 0.0
        var altmin = Double.infinity
        var altmax = 0.0
        for index in runTable {
            avg+=index.speed
            if index.speed>max {
                max = index.speed
            }
            if index.altitude < altmin {
                altmin = Double(index.altitude.description)!
            }
            if index.altitude > altmax {
                altmax = Double(index.altitude.description)!
            }
        }
        avg/=Double(runTable.count)
        return Stats(time: time, timestampStart: runTable.first!.timestamp.timeIntervalSince1970, timestampStop: runTable.last!.timestamp.timeIntervalSince1970, distance: distance, avgSpeed: avg, maxSpeed: max, altitudeMin: altmin, altitudeMax: altmax, training: runTable)
    }
    
    
}
