//
//  CALayerExtension.swift
//  FoodSpace
//
//  Created by Corey Howell on 10/30/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

extension CALayer {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}
