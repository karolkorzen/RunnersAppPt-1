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
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: textColour])
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
    
    /// function returns a standard button with text as normal string with font size by default 16, text color .white and cell background .mainAppColor
    /// - Parameters:
    ///   - text: text inside button
    ///   - textSize: CGFloat size of button
    ///   - textColor: text color
    ///   - backgroundColor: background color of button
    /// - Returns: UIButton
    func standardButton(withString text: String, withTextSize textSize: CGFloat = 16, withTextColour textColor: UIColor = UIColor.white, withBackGroundColor backgroundColor: UIColor = UIColor.mainAppColor) -> UIButton {
        let button = UIButton(type: .system)
        
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
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
    
    /// function returs UIButton for new post or new message with decared systemName icon and optional color
    /// - Parameters:
    ///   - systemName: SF Symbolname
    ///   - color: UIColor
    /// - Returns: UIButton
    func actionButton(withSystemName systemName: String, withColor color: UIColor = .mainAppColor) -> UIButton{
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = color
        let runIconConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .default)
        let img = UIImage(systemName: systemName, withConfiguration: runIconConfig)
        button.setImage(img, for: .normal)
        
        return button
    }
    
    /// func returns SF icon
    /// - Parameters:
    ///   - systemName: image name
    ///   - color: color (by default .mainAppColor)
    /// - Returns: UIImageView
    func monthIconRunList(withColor color: UIColor = .mainAppColor) -> UIImageView {
        let iv = UIImageView()
        iv.backgroundColor = color
        iv.layer.cornerRadius = 10
        return iv
    }
    
    /// func creates big label (applied for speed and distance in run controller)
    /// - Returns: UILabel
    func infoRunLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }
    
    /// func creates label with bold color of default size 14
    /// - Parameter size: text
    /// - Returns: UILabel
    func boldLabel(withSize size: CGFloat = 14) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: size)
        label.tintColor = .appTintColor
        return label
    }
    
    /// func creates  standar label of default size 14 and default weight .back
    /// - Parameters:
    ///   - size: font size
    ///   - weight: weight
    /// - Returns: UILabel
    func standardLabel(withSize size: CGFloat = 14, withWeight weight: UIFont.Weight = .black) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        label.tintColor = .appTintColor
        return label
    }
    
    /// func convers int to hours, minutes and seconds
    /// - Parameter seconds: int of seconds
    /// - Returns: hour, minutes, seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}

