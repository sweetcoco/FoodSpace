//
//  User.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/17/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var mealPlans: [MealPlan]?
    
    var profileImageUrl: String?
}
