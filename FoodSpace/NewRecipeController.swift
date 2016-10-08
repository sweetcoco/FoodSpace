//
//  NewRecipesController.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/29/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit
import Firebase

class NewRecipeController: UITableViewController {
    
    // ingredients the user has selected
    var ingredients = [Ingredient]()
    
    // ingredients on autocomplete
    var filteredIngredients = [Ingredient]()
    
    let cellId = "cellId"
    
    let searchController = UISearchController(searchResultsController: NewRecipeIngredientsSearchResultsController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        self.searchController.searchResultsController?.view.addObserver(self, forKeyPath: "hidden", options: [], context: nil)
        
        tableView.register(NewRecipeIngredientCell.self, forCellReuseIdentifier: cellId)
        
        // Add search bar as a the table header
        // and customize the searchbar
        
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = UIColor.white.cgColor
        searchController.searchBar.barTintColor = .white
        let searchBarBackground = UIImage.roundedImage(image: UIImage.imageWithColor(color: ColorPalette.BrandLightGrey, size: CGSize(width: 28, height: 28)), cornerRadius: 2)
        searchController.searchBar.setSearchFieldBackgroundImage(searchBarBackground, for: .normal)
        searchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(8, 0)
        
        //searchController.searchBar.backgroundImage = UIImage.fromColor(color: ColorPalette.BrandLightGrey)
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // hide the extra empty table cells
        //tableView.tableFooterView = UIView()
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white], for: .normal)
        
        navigationItem.title = "Recipes"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 20)!
        ]
        
        navigationController?.navigationBar.barTintColor = ColorPalette.BrandGreen
        navigationController?.navigationBar.backgroundColor = ColorPalette.BrandGreen
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let someView: UIView = object as! UIView? {
            
            if (someView == self.searchController.searchResultsController?.view &&
                (keyPath == "hidden") &&
                (searchController.searchResultsController?.view.isHidden)! &&
                searchController.searchBar.isFirstResponder) {
                
                searchController.searchResultsController?.view.isHidden = false
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchController.isActive && searchController.searchBar.text != "" {
//            return filteredIngredients.count
//        }
//        return ingredients.count
        
        let numberOfRows = ingredients.count
        
        if numberOfRows == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            emptyLabel.text = "Begin Searching for\nIngredients"
            emptyLabel.font = BaseTextView.Fonts.mediumRegularFont
            emptyLabel.textColor = ColorPalette.BrandLightGrey
            emptyLabel.numberOfLines = 2
            emptyLabel.textAlignment = .center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = .none
            return 0
        } else {
            return numberOfRows
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewRecipeIngredientCell
        
        let ingredient: Ingredient
        ingredient = ingredients[indexPath.row]
        cell.nameLabel.text = ingredient.name
        var description = ""
        
        if let quantity = ingredient.quantity {
            description.append("\(quantity) ")
        }
        
        if let unit = ingredient.unit {
            description.append("\(unit) ")
        }
        
        if let method = ingredient.method {
            description.append(method)
        }
        
        cell.subLabel.text = description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient: Ingredient
        ingredient = ingredients[indexPath.row]
        
        print(ingredient.name)
        print(ingredient.unit)
        print(ingredient.quantity)
        print(ingredient.method)
        
        // need to show the ingredient detail controller
        
        
//        let ingredientDetailController = IngredientDetailController()
//        ingredientDetailController.detailIngredient = ingredient
//        ingredientDetailController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//        ingredientDetailController.navigationItem.leftItemsSupplementBackButton = true
//        navigationController?.pushViewController(ingredientDetailController, animated: true)
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText.characters.count == 0) {
            searchController.searchResultsController?.view.isHidden = false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchResultsController?.view.isHidden = true
    }
    
    var currentQuery = ""
    func filterContentForSearchText() {//searchText: String, scope: String = "All") {
        // this method fires every time you enter a character.
        
        if (currentQuery.characters.count >= 3) {
            let ref = FIRDatabase.database().reference().child("search")
            // create a unique id
            let key = ref.child("request").childByAutoId().key
            // write to the unique id
            let query = ["index": "firebase", "type": "ingredient", "query": "*\(currentQuery)*"]
            ref.child("request").child(key).updateChildValues(query)
            
            
            ref.child("response/\(key)").observe(FIRDataEventType.value, with: { (snapshot) in
                
                // lets update filteredIngredients all at once.
                var newFilteredIngredients = [Ingredient]()
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    if let hits = dictionary["hits"] {
                        
                        if let hitsDictionaryArray = hits as? [[String: AnyObject]] {
                            
                            for recordAsDictionary: [String: AnyObject] in hitsDictionaryArray {
                                
                                guard let id: String = recordAsDictionary["_id"] as? String else {
                                    print("WARNING: Could not find value for id in \(#file) at line: \(#line)")
                                    return
                                }
                                
                                if let ingredient: [String: AnyObject] = recordAsDictionary["_source"] as? [String: AnyObject] {
                                    
                                    guard let category: String = ingredient["group"] as? String else {
                                        print("WARNING: Could not find value for category in \(#file) at line: \(#line)")
                                        print("Failed ingredient: ")
                                        print(ingredient)
                                        return
                                    }
                                    guard let name: String = ingredient["name"] as? String else {
                                        print("WARNING: Could not find value for name in \(#file) at line: \(#line)")
                                        print("Failed ingredient: ")
                                        print(ingredient)
                                        return
                                    }
                                    
                                    guard let ndbno: Int = (ingredient["ndbno"] as? NSString)?.integerValue else {
                                        print("WARNING: Could not find value for ndbno in \(#file) at line: \(#line)")
                                        print("Failed ingredient: ")
                                        print(ingredient)
                                        return
                                    }
                                    
                                    guard let newIngredient = Ingredient(category: category, name: name, ndbno: ndbno) else {
                                        print("WARNING: Could not create Ingredient in \(#file) at line: \(#line)")
                                        print("Failed ingredient: ")
                                        print(ingredient)
                                        return
                                    }
                                    
                                    newFilteredIngredients.append(newIngredient)
                                    
                                }
                            } // for recordAsDictionary
                            
                            self.filteredIngredients = newFilteredIngredients
                            
                            // get a reference to the searchResultsController to pass in the new ingredients
                            if let searchResultsController: NewRecipeIngredientsSearchResultsController = self.searchController.searchResultsController as! NewRecipeIngredientsSearchResultsController? {
                                
                                searchResultsController.ingredients = self.filteredIngredients
                                searchResultsController.newRecipeController = self
                            }
                            
                        } // hitsDictionary
                    } // hits
                } // dictionary
            }) // ref.child("response")
        }
    }
    
    
    func handleCancel() {
        self.searchController.searchResultsController?.view.removeObserver(self, forKeyPath: "hidden", context: nil)
        dismiss(animated: true, completion: nil)
    }

    
}

extension NewRecipeController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let newQuery = searchController.searchBar.text!
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(filterContentForSearchText), object: nil)
        
        // now that we've cancelled the previous query, lets update the current query string.
        // we do this because if the cancel doesn't happen, we don't want to update the string yet.
         currentQuery = newQuery
        
        perform(#selector(filterContentForSearchText), with: nil, afterDelay: 1)
        //filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}









