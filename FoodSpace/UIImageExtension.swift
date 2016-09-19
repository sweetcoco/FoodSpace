//
//  UIImageExtension.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/14/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func fromColor(color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img!
    }
}
