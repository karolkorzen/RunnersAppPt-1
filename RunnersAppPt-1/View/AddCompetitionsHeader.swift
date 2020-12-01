//
//  AddCompetitionsHeader.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 01/12/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

class AddCompetitionsHeader: UIView {
    
    //MARK: - Properties
    
    private var nameTextField = Utilities.shared.textField(withPlaceholder: "Competition Name")
    
    private var datePicker: UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date.init()
        return datePicker
    }
    
    private var distanceTextField = Utilities.shared.textField(withPlaceholder: "Distance")
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
        
    func configUI(){
        addSubview(nameTextField)
        addSubview(datePicker)
        addSubview(distanceTextField)
        distanceTextField.keyboardType = .numberPad
        
        nameTextField.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 10, paddingRight: 10, height: frame.height/5)
        datePicker.anchor(top: nameTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: frame.height/5)
        distanceTextField.anchor(top: distanceTextField.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: frame.height/5)
    }
}
