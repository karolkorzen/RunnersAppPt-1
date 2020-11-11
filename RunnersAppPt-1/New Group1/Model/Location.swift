//
//  Location.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 29/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import MapKit

struct Location {
    
    let readNumber: Int
    
    let longitude: Double
    let latitude: Double
    /// in meters
    let horizontalAccuracy: Double?
    
    
    /// in meters per second but rounded to 1st decimal
    let speed: Double
    /// in meters per second
    let speedAccuracy: Double?
    
    
    /// in meters
    let altitude: Double
    /// in numbers
    let floor: Int?
    /// in meters
    let verticalAccuracy: Double?
    
    
    let timestamp: Date
    
    
    /// from -180 to 180. 0 is north
    let course: Double
    /// The lower the value the more precise thedirection is.  A negative accuracy value indicates an invalid direction.
    let courseAccuracy: Double?
    
    init(withCLLoaction location: CLLocation, withNumber number: Int = -1) {
        self.readNumber = number
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
        self.horizontalAccuracy = location.horizontalAccuracy
        self.speed = round(location.speed*10)/10
        self.speedAccuracy = location.speedAccuracy
        self.altitude = location.altitude.binade
        self.floor = location.floor?.level
        self.verticalAccuracy = location.verticalAccuracy
        self.timestamp = location.timestamp
        self.course = location.course
        self.courseAccuracy = location.courseAccuracy
    }
    
    init(readNumber: Int, altitude: Double, course: Double, longitude: Double, latitude: Double, speed: Double, timestamp: Double){
        self.readNumber = readNumber
        self.altitude = altitude
        self.course = course
        self.longitude = longitude
        self.latitude = latitude
        self.speed = speed
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        self.horizontalAccuracy = nil
        self.verticalAccuracy = nil
        self.speedAccuracy = nil
        self.courseAccuracy = nil
        self.floor = nil
    }
    
    /// function returs FULL CLLocation
    /// - Returns: CLLocation
    func retFullCLLocation() -> CLLocation {
        return CLLocation(coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude), altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy!, verticalAccuracy: self.verticalAccuracy!, course: self.course, courseAccuracy: self.courseAccuracy!, speed: self.speed, speedAccuracy: self.speedAccuracy!, timestamp: self.timestamp)
    }
    
    /// Function returs  CLLocationCoordinate2D
    /// - Returns: CLLocationCoordinate2D
    func retCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
