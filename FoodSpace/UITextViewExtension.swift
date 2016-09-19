//
//  UITextViewExtension.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/17/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

extension UITextView {
    
    func scrollToBottom() {
        let range = NSMakeRange((text as NSString).length - 1, 1);
        scrollRangeToVisible(range);
    }
    
}
