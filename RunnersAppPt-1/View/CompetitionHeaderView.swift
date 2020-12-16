//
//  CompetitionHeaderView.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 07/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

class CompetitionHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    
    var competition: Competition? {
        didSet {
            configureUI()
        }
    }

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = .black
        return label
    }()


    private var startDateLabel = Utilities.shared.standardLabel()
    private var stopDateLabel = Utilities.shared.standardLabel()
    private var distanceLabel = Utilities.shared.standardLabel()

    private var startDateValueLabel = Utilities.shared.standardLabel()
    private var stopDateValueLabel = Utilities.shared.standardLabel()
    private var distanceValueLabel = Utilities.shared.standardLabel()
    
    //MARK: - Lifecycle
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func initUI(){
        layer.cornerRadius = 20
        backgroundColor = .systemGray6
    }
    
    func configureUI(){
        guard let competition = self.competition else {return}
        titleLabel.text = competition.title
        
        startDateLabel.text = "Start date:"
        stopDateLabel.text = "Stop date:"
        distanceLabel.text = "Goal:"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy HH:mm"
        
        startDateValueLabel.text = "\(formatter.string(from: competition.startDate))"
        stopDateValueLabel.text = "\(formatter.string(from: competition.stopDate))"
        distanceValueLabel.text = "\(competition.distance)"
        
        addSubview(titleLabel)
        
        addSubview(startDateLabel)
        addSubview(stopDateLabel)
        addSubview(distanceLabel)
        addSubview(startDateValueLabel)
        addSubview(stopDateValueLabel)
        addSubview(distanceValueLabel)
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10, width: 400, height: 50)
        
        startDateLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 10 , width: 150, height: 30)
        stopDateLabel.anchor(top: startDateLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 10, width: 150, height: 30)
        distanceLabel.anchor(top: stopDateLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 10, width: 150, height: 30)
        
        startDateValueLabel.anchor(top: titleLabel.bottomAnchor, left: startDateLabel.rightAnchor, paddingTop: 8, paddingRight: 10, width: 400, height: 30)
        stopDateValueLabel.anchor(top: startDateValueLabel.bottomAnchor, left: stopDateLabel.rightAnchor, paddingTop: 8,paddingRight: 10, width: 400, height: 30)
        distanceValueLabel.anchor(top: stopDateValueLabel.bottomAnchor, left: distanceLabel.rightAnchor, paddingTop: 8,paddingRight: 10, width: 400, height: 30)
    }
}
