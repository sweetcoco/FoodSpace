//
//  RecipesController.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/28/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import Foundation
import UIKit
import Popover
import Firebase

class RecipesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recipes = [Recipe]() {
        didSet {
            UserDefaults.standard.set(recipes.count, forKey: "recipe_count")
            print(UserDefaults.standard.value(forKey: "recipe_count"))
        }
    }
    
    let addMenu: UIView = {
        let uv = UIView()
        uv.backgroundColor = ColorPalette.BrandGreen
        return uv
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavBar()
        
        
        // if there are no recipes
        createEmptyView()
        
        //setupMenuBar()
        
        setupTableView()
        
        setupMenuBar()
        
        loadRecipes()
        
        tableView.register(RecipeCell.self, forCellReuseIdentifier: cellId)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.anchorWithConstantsToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: view.frame.height * 0.0775, rightConstant: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleAddRecipe))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 30)!
            ], for: .normal)
        
        navigationItem.title = "Recipes"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 20)!
        ]
        
        navigationController?.navigationBar.barTintColor = ColorPalette.BrandGreen
        navigationController?.navigationBar.backgroundColor = ColorPalette.BrandGreen
        
        edgesForExtendedLayout = []
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.currentViewController = self
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        menuBar.currentMenuIndex = 1
        
        
        menuBar.anchorToTop(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        menuBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.0775).isActive = true
    }
    
    var displayingPopover: Popover?
    
    func handleAddRecipe(sender: AnyObject?) {
        // https://github.com/corin8823/Popover
        // this is weird but we need the x and y of the bar button that was touched
        guard let buttonView: UIView = sender?.view else {
            return
        }
        
        let menuOptionText: BaseTextView = {
            let tv = BaseTextView()
            tv.textColor = .white
            tv.text = "Create New Recipe..."
            tv.font = BaseTextView.Fonts.extraSmallRegularFont
            tv.isUserInteractionEnabled = true
            return tv
        }()
        
        let navigationBarViewY = navigationController?.navigationBar.frame.maxY

        let startPoint = CGPoint(x: buttonView.frame.midX, y: navigationBarViewY!)
        let aView = UIView(frame: CGRect(x: buttonView.frame.minX, y: 0, width: self.view.frame.width * 0.5, height: 35))
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(presentAddRecipeModal))
        aView.addGestureRecognizer(tapView)
        
        aView.addSubview(menuOptionText)
        menuOptionText.anchorToTop(top: aView.topAnchor, left: aView.leftAnchor, bottom: aView.bottomAnchor, right: aView.rightAnchor)
        let options = [
            .type(.down),
            .cornerRadius(0),
            .animationIn(0.3),
            .color(ColorPalette.BrandGreen)
            //.blackOverlayColor(.clear),
            ] as [PopoverOption]
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        //popover.show(aView, fromView: buttonView)
        popover.show(aView, point: startPoint)
        
        displayingPopover = popover
    }
    
    func presentAddRecipeModal() {
        displayingPopover?.dismiss()
        
        
        let newRecipeController = EditRecipeController()
        let navController = UINavigationController(rootViewController: newRecipeController)
        present(navController, animated: true, completion: nil)
    }
    
    let emptyView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    private func createEmptyView() {
        view.addSubview(emptyView)
        emptyView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        
        if UserDefaults.standard.value(forKey: "recipe_count") as! Int == 0 {
            createEmptyViewContent()
        }
    }
    
    func createEmptyViewContent() {
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named: "3 Lines - Nothing Here")
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.backgroundColor = .clear
            return iv
        }()
        
        let textView: BaseTextView = {
            let tv = BaseTextView()
            tv.text = "Nothing Here."
            tv.font = BaseTextView.Fonts.mediumRegularFont
            tv.textColor = ColorPalette.BrandLightGrey
            return tv
        }()
        
        emptyView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        emptyView.addSubview(textView)
        textView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func loadRecipes() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userRecipeRef = FIRDatabase.database().reference().child("user-recipes").child(uid)
        
        userRecipeRef.observe(.childAdded, with: { (snapshot) in
            
            let recipeId = snapshot.key
            let recipesRef = FIRDatabase.database().reference().child("recipes").child(recipeId)
            recipesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let recipeDictionary = snapshot.value as? [String: Any] else {
                    print(snapshot.value)
                    return print("could not convert recipes to dictionary")
                }
                
                let recipe = Recipe()
                
                if let recipeName: String = recipeDictionary["name"] as? String {
                    recipe.name = recipeName
                }
                
                guard let ingredientsDictionaryArray: [[String: Any]] = recipeDictionary["ingredients"] as? [[String : Any]] else {
                     return print("could not convert ingredients to dictionary")
                }
                
                for ingredient in ingredientsDictionaryArray {
                    
                    guard let name: String = ingredient["name"] as? String else {
                        return print("could not convert ingredient name to String")
                    }
                    
                    guard let category: String = ingredient["category"] as? String else {
                        return print("could not convert ingredient category to String")
                    }
                    
                    guard let ndbno: Int = ingredient["ndbno"] as? Int else {
                        return print("could not convert ingredient ndbno to Int")
                    }
                    
                    guard let _ingredient = Ingredient(category: category, name: name, ndbno: ndbno) else {
                        return
                    }
                    
                    if let unit: String = ingredient["unit"] as? String {
                        _ingredient.unit = unit
                    }
                    
                    if let quantity: Double = ingredient["quantity"] as? Double {
                        _ingredient.quantity = quantity
                    }
                    
                    if let method: String = ingredient["method"] as? String {
                        _ingredient.method = method
                    }
                    
                    recipe.ingredients?.append(_ingredient)
                    
                }
                
                self.recipes.append(recipe)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    
                })
                
                
                
                
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = recipes.count
        
        if numberOfRows == 0 {
            tableView.isHidden = true
            return 0
        } else {
            tableView.isHidden = false
            return numberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RecipeCell
        cell.accessoryType = .disclosureIndicator
        
        let recipe: Recipe
        recipe = recipes[indexPath.row]
        cell.nameLabel.text = recipe.name
        var description = ""
        
        if let ingredientCount = recipe.ingredients?.count {
            description.append("\(ingredientCount) ")
            
            ingredientCount > 1 ? description.append("Ingredients, ") : description.append("Ingredient, ")
        }
        
        func random(upper: Int) -> Int {
            return 1 + Int(arc4random_uniform(UInt32(upper - 1 + 1)))
        }
        
        description.append("\(random(upper: 12)).\(random(upper: 60)) Hour Prep Time")
        
        cell.subLabel.text = description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("something")
    }
    
    
    
    
    

}
















