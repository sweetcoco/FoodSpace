//
//  NewRecipeIngredientsSearchResultsController.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/30/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class NewRecipeIngredientsSearchResultsController: UITableViewController {
    
    var ingredients = [Ingredient]() {
        didSet {
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    // we need to allow this controller to write selected ingredients to the newRecipeController
    var newRecipeController: RecipeController?
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NewRecipeIngredientCell.self, forCellReuseIdentifier: cellId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewRecipeIngredientCell
        cell.accessoryType = .disclosureIndicator
        let ingredient = ingredients[indexPath.row]
        
        cell.textLabel?.text = ingredient.name!
        cell.textLabel?.font = BaseTextView.Fonts.smallRegularFont

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient: Ingredient
        ingredient = ingredients[indexPath.row]
        
        let ingredientDetailNavController: UINavigationController = UINavigationController(rootViewController: IngredientDetailController())
        
        if let ingredientDetailController: IngredientDetailController = ingredientDetailNavController.topViewController as? IngredientDetailController {
            ingredientDetailController.hasAdd = true
            ingredientDetailController.detailIngredient = ingredient
        }
        
        present(ingredientDetailNavController, animated: true, completion: nil)
        
        // this is actually useful for when the user clicks "add" int the
//        DispatchQueue.main.async(execute: {
//            self.newRecipeController?.searchController.isActive = false
//        })
    }

}





