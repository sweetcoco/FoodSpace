//
//  UIViewExtension.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/13/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchorToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top: top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
        }
        
    }
    
    
    func addTopBorderWithColor(color: UIColor, andWidth borderWidth: CGFloat) {
        let border: UIView = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: borderWidth)
        self.addSubview(border);
    }
    
    func addBottomBorderWithColor(color: UIColor, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: borderWidth)
        self.addSubview(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        self.addSubview(border)
    }
    
    func addRightBorderWithColor(color: UIColor, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
        self.addSubview(border)
    }
    
    
    func foodspaceBrandedString(size: CGFloat, color: UIColor) -> NSMutableAttributedString {
        
        //["Lato-Black", "Lato-Bold", "Lato-Italic", "Lato-Regular", "Lato-Hairline", "Lato-Light"]
        
        let foodspaceBrandedString = NSMutableAttributedString(string: "food", attributes: [NSFontAttributeName: UIFont(name: "Lato-Light", size: size)!, NSForegroundColorAttributeName: color])
        
        foodspaceBrandedString.append(NSAttributedString(string: "space", attributes: [NSFontAttributeName: UIFont(name: "Lato-Bold", size: size)!, NSForegroundColorAttributeName: color]))
        
        return foodspaceBrandedString
    }
    
    func thinBoldThinAttributedString(thin: String, bold: String, secondThin: String?, size: CGFloat, color: UIColor) -> NSMutableAttributedString {
        let _string = NSMutableAttributedString(string: thin, attributes: [NSFontAttributeName: UIFont(name: "Lato-Light", size: size)!, NSForegroundColorAttributeName: color])
        
        _string.append(NSAttributedString(string: bold, attributes: [NSFontAttributeName: UIFont(name: "Lato-Bold", size: size)!, NSForegroundColorAttributeName: color]))
        
        if let _secondThin = secondThin {
            _string.append(NSAttributedString(string: _secondThin, attributes: [NSFontAttributeName: UIFont(name: "Lato-Light", size: size)!, NSForegroundColorAttributeName: color]))
        }
        
        return _string
    }
    
    func getStatusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
}





















