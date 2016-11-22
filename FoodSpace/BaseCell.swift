//
//  BaseCell.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/17/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
