//
//  Ingredient.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/29/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class Ingredient: NSObject {
    var id: String?
    var name: String?
    var category: String?
    var ndbno: Int?
    
    var unit: String?
    var quantity: Double?
    var method: String?
    
    init?(category: String, name: String, ndbno: Int) {
        self.category = category
        self.name = name
        self.ndbno = ndbno
    }
}
