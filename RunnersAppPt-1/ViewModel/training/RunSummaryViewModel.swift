//
//  RunSummaryViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 25/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import Charts

class RunSummaryViewModel {
    
    var stats = Stats()
    
    init() {
    }
    
    init(withStats stats: Stats) {
        self.stats = stats
    }
    
    var centerLocation: CLLocationCoordinate2D {
        let middle = stats.training!.count/2
        return stats.training![middle].retCLLocationCoordinate2D()
    }
    
    var polylines: [MKOverlay] {
        var polylines: [MKOverlay] = []
        var locations: [CLLocationCoordinate2D] = []
        for index in stats.training!.enumerated() {
            locations.append(index.element.retCLLocationCoordinate2D())
        }
        let polyline = MKPolyline(coordinates: locations, count: stats.training!.count)
        polylines.append(polyline)
        return polylines
    }
    
    var timeLabelText: String {
        let (hours, minutes, seconds) = Utilities.shared.secondsToHoursMinutesSeconds(seconds: Int(stats.time))
        if hours == 0{
            return ("Time:\n\(minutes) minutes, \(seconds) s")
        } else {
            return ("Time:\n\(hours) hours, \(minutes) minutes, \(seconds) seconds")
        }
//        return "Time:\n\(Int(stats.time/60)) minutes"
    }
    
    var distanceLabelText: String {
        return "Distance:\n\(round(stats.distance)) m"
    }
    
    var minAltitudeLabelText: String {
        return "minimum altitude:\n\(stats.altitudeMin) metres"
    }
    
    var maxAltitudeLabelText: String {
        return "maximum altitude:\n\(stats.altitudeMax) metres"
    }
    
    var avgSpeedLabelText: String {
        return "average speed:\n\(round(stats.avgSpeed*3.6*10)/10) km/h"
    }
    
    var maxSpeedLabelText: String {
        return "max speed:\n\(round(stats.maxSpeed*3.6*10)/10) km/h"
    }
    
    var speedChartTable: [ChartDataEntry] {
        var table: [ChartDataEntry] = []
        for index in stats.training!.enumerated() {
            table.append(ChartDataEntry(x: Double(index.offset), y: index.element.speed))
        }
        return table
    }
}
