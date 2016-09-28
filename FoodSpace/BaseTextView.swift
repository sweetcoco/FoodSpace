//
//  BaseTextView.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/27/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class BaseTextView: UITextView {
    
    private struct FontFamily {
        static let light = "Lato-Light"
        static let regular = "Lato-Regular"
        static let bold = "Lato-Bold"
    }
    
    private struct FontSize {
        static let large: CGFloat = 30
        static let medium: CGFloat = 23
        static let small: CGFloat = 14
    }
    
    public struct Fonts {
        static let largeLightFont = UIFont(name: FontFamily.light, size: FontSize.large)
        static let largeRegularFont = UIFont(name: FontFamily.regular, size: FontSize.large)
        static let largeBoldFont = UIFont(name: FontFamily.bold, size: FontSize.large)
        
        static let mediumLightFont = UIFont(name: FontFamily.light, size: FontSize.medium)
        static let mediumRegularFont = UIFont(name: FontFamily.regular, size: FontSize.medium)
        static let mediumBoldFont = UIFont(name: FontFamily.bold, size: FontSize.medium)
        
        static let smallLightFont = UIFont(name: FontFamily.light, size: FontSize.small)
        static let smallRegularFont = UIFont(name: FontFamily.regular, size: FontSize.small)
        static let smallBoldFont = UIFont(name: FontFamily.bold, size: FontSize.small)
    }
    
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.isEditable = false
        self.backgroundColor = UIColor.clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isScrollEnabled = false
    }

}
