//
//  StatsViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 15/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

struct StatsViewModel {
    typealias TrainingList = RunService.TrainingsList
    
    var dict: TrainingList
    
    init(dict: TrainingList) {
        self.dict = dict
    }
    
    init(){
        self.dict = TrainingList()
    }
    
    var distanceText: String {
        var distance = 0.0
        for value in dict.values {
            distance += value.distance
        }
        return "\(distance/100) km"
    }
}
