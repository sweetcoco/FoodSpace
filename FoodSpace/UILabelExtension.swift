//
//  UILabelExtension.swift
//  FoodSpace
//
//  Created by Corey Howell on 11/9/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

extension UILabel {
    func setAppearanceAlignment(_ alignment: NSTextAlignment) {
        self.textAlignment = alignment
    }
    
    func appearanceAlignment() -> NSTextAlignment {
        return self.textAlignment
    }
}
