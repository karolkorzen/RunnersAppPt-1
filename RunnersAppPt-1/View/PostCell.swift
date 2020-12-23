//
//  PostCell.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 12/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import ActiveLabel

protocol PostCellDelegate: class {
    func handleProfileImageTapped(_ cell: PostCell)
    func handleReplyButtonTapped(_ cell: PostCell)
    func handleLikeButtonTapped(_ cell: PostCell)
    func handleFetchUser(withUserName username: String)
    func sharePostText(_ cell: PostCell)
    func handleTrainingTapped(_ trainingID: String, runnerID: String)
}

class PostCell: UICollectionViewCell{
    
    // MARK: - Properties
    
    var post: Post? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: PostCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .mainAppColor
        return label
    }()
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.mentionColor = .mainAppColor
        label.hashtagColor = .mainAppColor
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var runButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "hare"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRunTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel = UILabel()
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame:  frame)
        
        backgroundColor = .cellBackground
        layer.cornerRadius = 30
        
        let captionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionStack])
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 17, paddingLeft: 17, paddingBottom: 10, paddingRight: 17)
        
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
//        let underLineView = UIView()
//        underLineView.backgroundColor = .systemGroupedBackground
//        addSubview(underLineView)
//        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleCommentTapped() {
        delegate?.handleReplyButtonTapped(self)
    }
    
    @objc func handleRunTapped(){
        delegate?.handleTrainingTapped(post!.trainingID!, runnerID: post!.user.uid)
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeButtonTapped(self)
    }
    
    @objc func handleShareTapped(){
        delegate?.sharePostText(self)
    }
    
    // MARK: - Helpers
    
    func configure(){
        guard let post = post else {return}
        let viewModel = PostViewModel(post: post)
        
        captionLabel.text = post.caption
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        infoLabel.attributedText = viewModel.userInfoText
        
        self.likeButton.tintColor = viewModel.likeButtonTintColor
        self.likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
        
        captionLabel.isUserInteractionEnabled = true
        if post.trainingID != nil {
            let actionStack = UIStackView(arrangedSubviews: [commentButton, /*repostButton,*/ likeButton, shareButton, runButton])
            actionStack.axis = .horizontal
            actionStack.spacing = 72
            addSubview(actionStack)
            actionStack.centerX(inView: self)
            actionStack.anchor(bottom: bottomAnchor, paddingBottom: 17)
        } else {
            let actionStack = UIStackView(arrangedSubviews: [commentButton, /*repostButton,*/ likeButton, shareButton/*, runButton*/])
            actionStack.axis = .horizontal
            actionStack.spacing = 72
            addSubview(actionStack)
            actionStack.centerX(inView: self)
            actionStack.anchor(bottom: bottomAnchor, paddingBottom: 17)
        }
    }
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    func configureMentionHandler() {
        captionLabel.handleMentionTap { (username) in
            self.delegate?.handleFetchUser(withUserName: username)
        }
    }
}
