//
//  TrainingListHeader.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 19/11/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

class TrainingListHeader: UICollectionReusableView {
    
    private var label = Utilities.shared.boldLabel(withSize: 22)
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        label.text = "Your Runs"
        label.tintColor = .mainAppColor
        label.backgroundColor = .white
        label.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
