//
//  NotificationCell.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 22/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate: class {
    func didTapProfileImage(_ cell: NotificationCell)
    func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var notification: Notification? {
        didSet{
            configure()
        }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        //iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.mainAppColor, for: .normal)
        //button.setDimensions(width: 92, height: 32)
        button.layer.cornerRadius = 16
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.mainAppColor.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "testnotificationmessage"
        return label
    }()
    
    private var stack = UIStackView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        followButton.setDimensions(width: 92, height: 32)
        profileImageView.setDimensions(width: 40, height: 40)
        stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel, followButton])
        stack.spacing = 12
        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        stack.alignment = .center
        
        //addSubview(followButton)
        
//      followButton.centerY(inView: self)
//      followButton.anchor(right: rightAnchor, paddingRight: 12)
        
        
        //stack.anchor(right: rightAnchor, paddingRight: 12, height: 60)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleFollowButtonTapped(){
        delegate?.didTapFollow(self)
    }
    
    @objc func handleProfileImageTapped() {
        delegate?.didTapProfileImage(self)
    }
    
    // MARK: - Helpers
    
    func configure() {
        
        guard let notification = notification else {return}
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        
        if viewModel.shouldHideFollowButton {
            followButton.isHidden = true
        } else {
            followButton.isHidden = false
        }
        //followButton.isHidden = viewModel.shouldHideFollowButton
        //followButton.setTitle(viewModel.followButtonText, for: .normal)
//        if followButton.isHidden {
//            notificationLabel.anchor(right: rightAnchor)
//        }
    }
}

