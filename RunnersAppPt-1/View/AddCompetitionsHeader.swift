//
//  AddCompetitionsHeader.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 01/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

protocol AddCompetitionsHeaderDelegate: class {
    func updateList(withText text: String)
}

class AddCompetitionsHeader: UIView {
    
    //MARK: - Properties
    weak var delegate: AddCompetitionsHeaderDelegate?
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Competition"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .appTintColor
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainAppColor
        button.setTitle("Create", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        return button
    }()
    
    private var nameLabel = Utilities.shared.standardLabel()
    private var startDateLabel = Utilities.shared.standardLabel()
    private var stopDateLabel = Utilities.shared.standardLabel()
    private var distanceLabel = Utilities.shared.standardLabel()
    private var inviteListLabel = Utilities.shared.standardLabel()
    
    private var nameTextField = Utilities.shared.textField(withPlaceholder: "Type title")
    private var distanceTextField = Utilities.shared.textField(withPlaceholder: "Type distance in meters")
    private var usersTextField = Utilities.shared.textField(withPlaceholder: "Search User")
    
    private var startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date.init()
        return datePicker
    }() {
        didSet {
            stopDatePicker.minimumDate = startDatePicker.date
        }
    }
    
    private var stopDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date.init()
        return datePicker
    }() {
        didSet {
            startDatePicker.maximumDate = stopDatePicker.date
        }
    }
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI(withFrame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func createTapped(){
        
    }
    
    @objc func handleUpdateSearchField() {
        delegate?.updateList(withText: usersTextField.text ?? "")
    }
    
    //MARK: - Helpers
        
    func configUI(withFrame frame: CGRect){
        layer.cornerRadius = 20
        backgroundColor = .systemGray6
        
        addSubview(titleLabel)
        addSubview(actionButton)
        addSubview(nameLabel)
        addSubview(startDateLabel)
        addSubview(distanceLabel)
        addSubview(stopDateLabel)
        addSubview(nameTextField)
        addSubview(startDatePicker)
        addSubview(stopDatePicker)
        addSubview(distanceTextField)
        addSubview(inviteListLabel)
        addSubview(usersTextField)
        
        distanceTextField.keyboardType = .numberPad
        distanceTextField.backgroundColor = .systemGray5
        nameTextField.backgroundColor = .systemGray5
        usersTextField.backgroundColor = .systemGray5
        nameTextField.layer.cornerRadius = 5
        distanceTextField.layer.cornerRadius = 5
        usersTextField.layer.cornerRadius = 5
        distanceTextField.textColor = .black
        nameTextField.textColor = .black
        usersTextField.textColor = .black
        
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10, width: 200, height: 50)
        actionButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 10, width: 100, height: 30)
        
        nameLabel.text = "Title:"
        startDateLabel.text = "Start Date:"
        stopDateLabel.text = "Stop Date:"
        distanceLabel.text = "Distance to beat:"
        inviteListLabel.text = "Invite People:"
        
        nameLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10 , width: 150, height: 50)
        distanceLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10, width: 150, height: 50)
        startDateLabel.anchor(top: distanceLabel.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10, width: 150, height: 50)
        stopDateLabel.anchor(top: startDateLabel.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10, width: 150, height: 50)
        inviteListLabel.anchor(top: stopDateLabel.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10, width: 150, height: 50)
        
        nameTextField.anchor(top: titleLabel.bottomAnchor, left: nameLabel.rightAnchor, paddingTop: 20, paddingRight: 10, width: 200, height: 30)
        distanceTextField.anchor(top: nameLabel.bottomAnchor, left: distanceLabel.rightAnchor, paddingTop: 20,paddingRight: 10, width: 200, height: 30)
        startDatePicker.anchor(top: distanceLabel.bottomAnchor, left: startDateLabel.rightAnchor, paddingTop: 10,paddingRight: 10, width: 200, height: 50)
        stopDatePicker.anchor(top: startDateLabel.bottomAnchor, left: stopDateLabel.rightAnchor, paddingTop: 10,paddingRight: 10, width: 200, height: 50)
        usersTextField.anchor(top: stopDateLabel.bottomAnchor, left: inviteListLabel.rightAnchor, paddingTop: 20, paddingRight: 10, width: 200, height: 30)
        
        usersTextField.addTarget(self, action: #selector(handleUpdateSearchField), for: .allEditingEvents)
    }
}
