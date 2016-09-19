//
//  MealPlanCell.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/17/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class MealPlanCell: BaseCell {
    
    var mealPlan: MealPlan? {
        didSet {
            titleView.text = mealPlan?.title?.uppercased()
            titleView.scrollToBottom()
            titleView.isScrollEnabled = false
            
            guard let recipeCount = mealPlan?.recipeCount, let ingredientCount = mealPlan?.ingredientCount, let prepTime = mealPlan?.prepTime else {
                return
            }
            
            let recipeIngredientText = "\(String(describing: recipeCount)) Recipes with \(String(describing: ingredientCount)) ingredients"
            recipeIngredientCountView.text = recipeIngredientText
            recipeIngredientCountView.scrollToBottom()
            recipeIngredientCountView.isScrollEnabled = false
            
            prepTimeView.text = "\(String(describing: prepTime)) Hour Preparation Time"
            prepTimeView.scrollToBottom()
            prepTimeView.isScrollEnabled = false
        }
    }
    
    let titleView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Lato-Regular", size: 23)
        tv.backgroundColor = .clear
        tv.textColor = .white
        return tv
    }()
    
    let recipeIngredientCountView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Lato-Regular", size: 14)
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.textColor = .white
        return tv
    }()
    
    let prepTimeView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: "Lato-Regular", size: 14)
        tv.backgroundColor = .clear
        tv.textColor = .white
        return tv
    }()
    
    override func setupViews() {
        self.layer.cornerRadius = 5
        self.backgroundColor = ColorPalette.BrandLightGrey
        
        
        addSubview(titleView)
        addSubview(recipeIngredientCountView)
        addSubview(prepTimeView)
        
        let leftConstant: CGFloat = 30
        
        titleView.anchorWithConstantsToTop(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 5, leftConstant: leftConstant, bottomConstant: 0, rightConstant: 5)
        titleView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        recipeIngredientCountView.anchorWithConstantsToTop(top: titleView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: -5, leftConstant: leftConstant, bottomConstant: 0, rightConstant: 0)
        recipeIngredientCountView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        prepTimeView.anchorWithConstantsToTop(top: recipeIngredientCountView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: -5, leftConstant: leftConstant, bottomConstant: 0, rightConstant: 0)
        prepTimeView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
}
