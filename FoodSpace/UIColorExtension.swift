//
//  UIColorExtension.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/15/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
