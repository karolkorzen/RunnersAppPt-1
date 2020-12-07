//
//  CompetitionCell.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 07/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

protocol CompetitionCellDelegate: class {
    func presentProfile(withUser user: User)
}

class CompetitionCell: UICollectionViewCell{
    
    //MARK: - Properties
    
    var user: User? {
        didSet{
            configure()
        }
    }
    
    var distance: Double? {
        didSet {
            distanceLabel.text = "\(Int(distance!)) metres"
        }
    }
    
    weak var delegate: CompetitionCellDelegate?
    
    private lazy var userName = Utilities.shared.standardLabel(withSize: 14, withWeight: .heavy)
    private lazy var distanceLabel = Utilities.shared.standardLabel(withSize: 14, withWeight: .bold)
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePopUpImageProfile))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    //MARK: - Lifecycle
    
    init(withUser user: User, withDistance distance: Double, withFrame frame: CGRect) {
        self.user = user
        self.distance = distance
        super.init(frame: frame)
        backgroundColor = .cellBackground
        layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cellBackground
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handlePopUpImageProfile() {
        guard let user = self.user else {return}
        delegate?.presentProfile(withUser: user)
    }
    
    //MARK: - Helpers
    
    func configure(){
        guard let user = self.user else {return}
        userName.text = user.fullname
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        addSubview(userName)
        addSubview(distanceLabel)
        addSubview(profileImageView)
        
        distanceLabel.numberOfLines = 2
        
        
        profileImageView.setDimensions(width: frame.width/2-20, height: frame.height/2)
        profileImageView.centerY(inView: self)
        userName.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor , paddingTop: 10, paddingLeft: 10, height: frame.height/2-20)
        distanceLabel.anchor(top: userName.bottomAnchor, left: profileImageView.rightAnchor, paddingLeft: 5, width: frame.width/2-10, height: frame.height/2)
    }
}
