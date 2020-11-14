//
//  TrainingMonthCell.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 11/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

class TrainingListCell: UICollectionViewCell{
    
    //MARK: - Properties
    typealias TrainingsList = RunService.TrainingsList
    var viewModel: TrainingViewModel? {
        didSet{
            configure()
        }
    }
    
    private lazy var dateLabel = Utilities.shared.standardLabel(withSize: 14, withWeight: .heavy)
    private lazy var hourLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .light)
    private lazy var distanceLabel = Utilities.shared.standardLabel(withSize: 30, withWeight: .bold)
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cellBackground
        layer.cornerRadius = 10
        
        addSubview(dateLabel)
        addSubview(hourLabel)
        dateLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        hourLabel.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, paddingTop: 0, paddingLeft: 10)
        
        addSubview(distanceLabel)
        distanceLabel.center(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure(){
        dateLabel.text = viewModel!.dateLabelText
        hourLabel.text = viewModel!.hourLabelText
        distanceLabel.text = viewModel!.distanceLabelText
    }
}
