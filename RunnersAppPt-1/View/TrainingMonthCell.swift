//
//  TrainingMonthCell.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 11/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

class TrainingMonthCell: UICollectionViewCell{
    
    //MARK: - Properties
    typealias TrainingsList = RunService.TrainingsList
    var viewModel: MonthViewModel? {
        didSet{
            configure()
        }
    }
    
    private lazy var monthLabel = Utilities.shared.boldLabel()
    private lazy var trainingsInMonthNumLabel = Utilities.shared.monthIconRunList()
    //private var optionsLabel ADD TO DELETE MONTH OR SMTH
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cellBackground
        layer.cornerRadius = 20
        
        let stack = UIStackView(arrangedSubviews: [trainingsInMonthNumLabel, monthLabel])
        stack.distribution = .fill
        stack.spacing = frame.height/6
        stack.axis = .horizontal
        addSubview(stack)
        
        monthLabel.font = UIFont.boldSystemFont(ofSize: frame.height/5)
        trainingsInMonthNumLabel.setDimensions(width: frame.height/3*2, height: frame.height/3*2)
        
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: frame.height/6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure(){
        monthLabel.text = viewModel!.monthYearName
        trainingsInMonthNumLabel.image = UIImage(systemName: viewModel!.numberOfTrainings)
    }
}
