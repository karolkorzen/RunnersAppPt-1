//
//  TrainingListViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 11/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

struct TrainingListViewModel {
    typealias TrainingList = RunService.TrainingsList
    
    var dict: TrainingList
    
    init(dict: TrainingList) {
        self.dict = dict
    }
    
    init(){
        self.dict = TrainingList()
    }
    
    var numberOfTrainings: Int {
        return dict.count
    }
}


