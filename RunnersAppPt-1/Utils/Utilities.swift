//
//  Utilities.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 09/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

/// Function contains UIElements defined proggramaticly
class Utilities {
    
    /// object that allow us to take funcs from class without constructing its object
    static let shared = Utilities()
    
    
    
    /// function returs input view with image and textfield right next to it with white divider of height = 0.75 and white colour with paddings = 8
    /// - Parameters:
    ///   - image: image
    ///   - textField: text field
    ///   - viewHeight: height of whole view (by default 50)
    ///   - imageHeightandWidth: image height and width (by default 24)
    /// - Returns: UIView object
    func inputContainerView(withImage image: UIImage, textField: UITextField, viewHeight: CGFloat = 50, imageHeightandWidth: CGFloat = 24) -> UIView {
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        iv.image = image
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: imageHeightandWidth, height: imageHeightandWidth)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right:  view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right:  view.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 0.75)
        return view
    }
    
    /// Fuction returs UITextField for defined placeholder, font size, bold or not, text colour
    /// - Parameters:
    ///   - placeholder: placeholder text
    ///   - fontSize: font size (by default 16)
    ///   - textColour: UIColor text colour (by default .white)
    ///   - isbold: if true will return bolded text if not normal
    /// - Returns: returns defined UITextField
    func textField(withPlaceholder placeholder: String, withFontSize fontSize: CGFloat = 16, withisBold isbold: Bool = false, withTextColour textColour: UIColor = .white) -> UITextField {
        let tf = UITextField()
        tf.textColor = textColour
        tf.font = isbold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
    
    /// fuction returns buttton with first part of text normal and second bolded with font 16 by default and white colour by default
    /// - Parameters:
    ///   - firstPart: first part of button's text
    ///   - secondPart: bolded second part of button's text
    ///   - textSize: text size (by default 16)
    ///   - textColor: text colour (by default .white)
    /// - Returns: UIButton
    func attributedButton(_ firstPart: String, _ secondPart: String, withTextSize textSize: CGFloat = 16, withTextColour textColor: UIColor = UIColor.white) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize), NSAttributedString.Key.foregroundColor: textColor])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textSize), NSAttributedString.Key.foregroundColor: textColor]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }
    
    /// function waits for exact delay and executes closure of caller's site
    /// - Parameters:
    ///   - delay: seconds of delay in Double
    ///   - closure: closure executes at caller's site
    /// - Returns: closure
    func dispatchDelay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
}

