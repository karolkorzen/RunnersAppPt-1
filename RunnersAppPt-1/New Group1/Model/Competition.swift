//
//  CompetitionModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 05/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

struct Competition {
    let id: String
    let title: String
    let distance: Double
    let startDate: Date
    let stopDate: Date
    let competitors: [User]
    
    init() {
        self.id = ""
        self.title = ""
        self.distance = 0.0
        self.startDate = Date()
        self.stopDate = Date()
        self.competitors = []
    }
    
    init(withID id: String, withTitle title: String, withDistance distance: Double, withStartDate startDate: Date, withStopDate stopDate: Date, withCompetitors competitors: [User] = []){
        self.id = id
        self.title = title
        self.distance = distance
        self.startDate = startDate
        self.stopDate = stopDate
        self.competitors = competitors
    }
}
