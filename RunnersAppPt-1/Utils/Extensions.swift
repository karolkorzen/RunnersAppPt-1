//
//  Extensions.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 08/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

extension UIView {
    
    /// func allows to set layout for view
    /// - Parameters:
    ///   - top: top anchor
    ///   - left: left anchor
    ///   - bottom: bottom anchor
    ///   - right: right anchor
    ///   - paddingTop: distance from top anchor
    ///   - paddingLeft: distance from left anchor
    ///   - paddingBottom: distance from bottom anchor
    ///   - paddingRight: distance from right anchor
    ///   - width: width of view
    ///   - height: height of view
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
    /// function centers object in view in X and Y axis
    /// - Parameters:
    ///   - view: view that we center in
    ///   - yConstant: offset for height
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    
    /// function centers object in view in X axis
    /// - Parameters:
    ///   - view: view that we center in
    ///   - topAnchor: topAnchor of that view
    ///   - paddingTop: distance from topAnchor
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    /// function centers object in view in Y axis
    /// - Parameters:
    ///   - view: view that we center in
    ///   - leftAnchor: leftAnchor of that view
    ///   - paddingLeft: distance from leftAnchor
    ///   - constant: offset for height
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    /// function sets dimensions for object
    /// - Parameters:
    ///   - width: width of object
    ///   - height: height of object
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    /// function sets all anchors for object same as for view
    /// - Parameter view: view in which we are filling view
    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

// MARK: - UIColor

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    /// function returs colour for R, G, B from 0 to 255 with opacity from 0.0 to 1.0
    /// - Parameters:
    ///   - red: red colour value
    ///   - green: green colour value
    ///   - blue: blue colour value
    ///   - opacity: opacity for colour
    /// - Returns: colour
    static func rgbOpacity(red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: opacity)
    }
    
    
    
    
    static let mainAppColor = blueish
    
    static let appTintColor = UIColor.darkGray
    static let secondaryAppColor = pinkish
    static let cellBackground = UIColor(red: 0.150, green: 0.250, blue: 0.300, alpha: 0.1)
    static let runButtonBackgroundColor = UIColor(red: 0.13, green: 0.19, blue: 0.25, alpha: 1.00)
    
    static let previousCellBackground = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
    static let pinkish = UIColor(red: 0.95, green: 0.66, blue: 0.63, alpha: 1.00)
    static let twitterBlue = UIColor.rgb(red: 29, green: 161, blue: 242)
    static let blueish = UIColor(red: 0.310, green: 0.416, blue: 0.561, alpha: 1.000)
}
