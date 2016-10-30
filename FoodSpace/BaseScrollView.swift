//
//  BaseScrollView.swift
//  FoodSpace
//
//  Created by Corey Howell on 10/24/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class BaseScrollView: UIScrollView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        return false
    }

}
