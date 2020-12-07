//
//  CompetitionsListCell.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 06/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

protocol CompetitionsListCellDelegate: class {
    func acceptInvite(withID id:String)
    func rejectInvite(withID id:String)
}

class CompetitionsListCell: UITableViewCell {
    
    weak var delegate: CompetitionsListCellDelegate?
    var competition: Competition? {
        didSet {
            configure()
        }
    }
    
    var isInvitation: Bool = false
    
    private lazy var titleLabel = Utilities.shared.standardLabel(withSize: 14, withWeight: .heavy)
    private lazy var datesLabel = Utilities.shared.standardLabel(withSize: 10, withWeight: .light)
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainAppColor
        button.setDimensions(width: 50, height: 50)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        return button
    }()
    
    private lazy var rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainAppColor
        button.setDimensions(width: 50, height: 50)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .cellBackground
        layer.cornerRadius = 10
        
        addSubview(titleLabel)
        addSubview(datesLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        datesLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, paddingTop: 0, paddingLeft: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleAccept(){
        guard let competition = competition else {return}
        delegate?.acceptInvite(withID: competition.id)
    }
    
    @objc func handleReject(){
        guard let competition = competition else {return}
        delegate?.rejectInvite(withID: competition.id)
    }
    
    // MARK: - Helpers
    
    func configure(){
        guard let competition = competition else {return}
        
        titleLabel.text = competition.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"

        datesLabel.text = "\(formatter.string(from: competition.startDate)) - \(formatter.string(from: competition.stopDate))"
        
        if isInvitation {
            acceptButton.setTitle("✔", for: .normal)
            rejectButton.setTitle("✖", for: .normal)
            addSubview(acceptButton)
            addSubview(rejectButton)
            rejectButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 10)
            acceptButton.anchor(top: topAnchor, right: rejectButton.leftAnchor, paddingTop: 10, paddingRight: 10)
        }
    }
}
