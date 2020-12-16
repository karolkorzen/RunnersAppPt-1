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
        button.setTitleColor(.mainAppColor, for: .normal)
        button.setDimensions(width: 36, height: 36)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainAppColor.cgColor
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        return button
    }()
    
    private lazy var rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.mainAppColor, for: .normal)
        button.setDimensions(width: 36, height: 36)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainAppColor.cgColor
        button.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
        return button
    }()
    
    private var numberLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 18
        label.textColor = .mainAppColor
        label.textAlignment = .center
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.mainAppColor.cgColor
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .bold)
        return label
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
        backgroundColor = .darkGray
        isUserInteractionEnabled = false
        acceptButton.isHidden = true
        rejectButton.isHidden = true
        numberLabel.isHidden = true
        guard let competition = competition else {return}
        delegate?.acceptInvite(withID: competition.id)
    }
    
    @objc func handleReject(){
        backgroundColor = .darkGray
        isUserInteractionEnabled = false
        acceptButton.isHidden = true
        rejectButton.isHidden = true
        numberLabel.isHidden = true
        guard let competition = competition else {return}
        delegate?.rejectInvite(withID: competition.id)
    }
    
    // MARK: - Helpers
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.x += 10
            let f = CGRect(x: frame.origin.x+8, y: frame.origin.y, width: frame.width-36, height: frame.height-10)
            super.frame = f
        }
    }
    
    func configure(){
        guard let competition = competition else {return}
        
        titleLabel.text = competition.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"

        datesLabel.text = "\(formatter.string(from: competition.startDate)) - \(formatter.string(from: competition.stopDate))"
        
        if isInvitation {
            acceptButton.isHidden = false
            rejectButton.isHidden = false
            numberLabel.isHidden = true
            acceptButton.setTitle("✔", for: .normal)
            rejectButton.setTitle("✖", for: .normal)
            addSubview(acceptButton)
            addSubview(rejectButton)
            rejectButton.anchor(right: rightAnchor, paddingRight: 10)
            acceptButton.centerY(inView: self)
            acceptButton.anchor(right: rejectButton.leftAnchor, paddingRight: 10)
            rejectButton.centerY(inView: self)
        } else {
            acceptButton.isHidden = true
            rejectButton.isHidden = true
            numberLabel.isHidden = false
            numberLabel.text = competition.competitors.count.description
            addSubview(numberLabel)
            numberLabel.setDimensions(width: 36, height: 36)
            numberLabel.anchor(right: rightAnchor, paddingRight: 10)
            numberLabel.centerY(inView: self)
        }
    }
}
