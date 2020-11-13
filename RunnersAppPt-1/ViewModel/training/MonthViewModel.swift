//
//  MonthViewModel.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 13/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import Foundation

struct MonthViewModel {
    typealias TrainingsList = RunService.TrainingsList
    
    let monthYearName: String
    let trainingsList: TrainingsList
    
    init(monthYearName: String, trainingsList: TrainingsList) {
        self.monthYearName = monthYearName
        self.trainingsList = trainingsList
    }
    
    //MARK: - Helpers
    
    var numberOfTrainings: String {
        return String(trainingsList.count)
    }
}
