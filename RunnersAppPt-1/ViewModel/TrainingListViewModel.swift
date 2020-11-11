//
//  TrainingListViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 11/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

struct TrainingListViewModel {
    typealias dateTrainingList = RunService.trainingsList
    
    var dict: dateTrainingList
    
    init(dict: dateTrainingList) {
        self.dict = dict
    }
    
    var numberOfTrainings: Int {
        return dict.count
    }
    
}


