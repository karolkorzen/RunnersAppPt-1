//
//  CompetitionHeaderModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 03/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

struct CompetitionHeader {
    let title: String
    let distance: Double
    let startDate: Date
    let stopDate: Date
    
    init(withTitle title: String, withDistance distance: Double, withStartDate startDate: Date, withStopDate stopDate: Date){
        self.title = title
        self.distance = distance
        self.startDate = startDate
        self.stopDate = stopDate
    }
}
