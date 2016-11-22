//
//  EditIngredientsController.swift
//  FoodSpace
//
//  Created by Corey Howell on 11/10/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit
import Firebase

class EditIngredientsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // ingredients the user has selected
    var ingredients = [Ingredient]()
    
    // ingredients on autocomplete
    var filteredIngredients = [Ingredient]()
    
    var parentView: UIViewController?
    
    let cellId = "cellId"
    
    let backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let searchController = UISearchController(searchResultsController: NewRecipeIngredientsSearchResultsController())

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        self.collectionView!.register(IngredientsCell.self, forCellWithReuseIdentifier: cellId)
        
        let collectionViewLayout: UICollectionViewFlowLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(52, 0, 0, 0)
        
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        self.searchController.searchResultsController?.view.addObserver(self, forKeyPath: "hidden", options: [], context: nil)
        
        searchController.hidesNavigationBarDuringPresentation = true
        //searchController.searchResultsController?.automaticallyAdjustsScrollViewInsets = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = UIColor.white.cgColor
        searchController.searchBar.barTintColor = .white
        let searchBarBackground = UIImage.roundedImage(image: UIImage.imageWithColor(color: ColorPalette.BrandLightGrey, size: CGSize(width: 28, height: 28)), cornerRadius: 2)
        searchController.searchBar.setSearchFieldBackgroundImage(searchBarBackground, for: .normal)
        searchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(8, 0)
        
        
//        collectionView?.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
//        searchController.searchBar.frame = CGRect(x: 0, y: -44, width: view.frame.size.width, height: 44)
        collectionView?.addSubview(searchController.searchBar)
        
        definesPresentationContext = true
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        collectionView?.addGestureRecognizer(longPressGesture)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        collectionView?.addGestureRecognizer(swipeGestureLeft)
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        collectionView?.addGestureRecognizer(swipeGestureRight)
        
        collectionView?.backgroundView = backgroundView
        deleteButton.addTarget(self, action: #selector(handleDeleteInstruction), for: .touchUpInside)
        

        setupNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white], for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white], for: .normal)
        
        navigationItem.title = "Ingredients"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 20)!
        ]
        
        navigationController?.navigationBar.barTintColor = ColorPalette.BrandGreen
        navigationController?.navigationBar.backgroundColor = ColorPalette.BrandGreen
        
        //edgesForExtendedLayout = []
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let someView: UIView = object as! UIView? {
            
            if (someView == self.searchController.searchResultsController?.view &&
                (keyPath == "hidden") &&
                (searchController.searchResultsController?.view.isHidden)! &&
                searchController.searchBar.isFirstResponder) {
                
                searchController.searchResultsController?.view.isHidden = false
                //searchController.searchResultsController?.view.frame = CGRect(x: 0, y: 108, width: view.frame.size.width, height: view.frame.size.height)
            }
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
                                //searchResultsController.newRecipeController = self
                            }
                            
                        } // hitsDictionary
                    } // hits
                } // dictionary
            }) // ref.child("response")
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return ingredients.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IngredientsCell
        let ingredient = ingredients[indexPath.item]
        var detailsString = ""
        
        if let quantity = ingredient.quantity {
            if quantity != Double(0.0) {
                let quantityTouple = Quantities.getFractionStringFromDecimal(decimal: quantity)
                let wholeNumber = quantityTouple.wholeNumber != 0 ? "\(quantityTouple.wholeNumber) " : ""
                detailsString.append("\(wholeNumber)\(quantityTouple.fractionString) ")
            }
        }
        
        if let unit = ingredient.unit {
            detailsString.append("\(unit)")
        }
        
        if detailsString.isEmpty {
            detailsString = "1 item"
        }
        cell.nameLabel.text = ingredient.name
        
        cell.detailsLabel.text = detailsString
        cell.backgroundColor = .white
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 60
        let width = UIScreen.main.bounds.width
        
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // move your data order
        
        let selectedIngredient = ingredients.remove(at: sourceIndexPath.item)
        ingredients.insert(selectedIngredient, at: destinationIndexPath.item)
        DispatchQueue.main.async(execute: {
            collectionView.reloadData()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIngredient: Ingredient = ingredients[indexPath.item]
        let ingredientDetailNavController: UINavigationController = UINavigationController(rootViewController: IngredientDetailController())
        
        if let ingredientDetailController: IngredientDetailController = ingredientDetailNavController.topViewController as? IngredientDetailController {
            ingredientDetailController.detailIngredient = selectedIngredient
        }
        
        present(ingredientDetailNavController, animated: true, completion: nil)
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView?.endInteractiveMovement()
        default:
            collectionView?.cancelInteractiveMovement()
        }
    }
    
    func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
            return
        }
        
        guard let cell = self.collectionView?.cellForItem(at: selectedIndexPath) else {
            return
        }
        
        if (gesture.direction == .left) {
            collectionView?.backgroundView?.addSubview(deleteButton)
            deleteButton.anchorWithConstantsToTop(top: nil, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 10)
            deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            deleteButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            deleteButton.backgroundColor = .red
            deleteIndexPath = selectedIndexPath
            
            let cellPosition = CGPoint(x: cell.frame.origin.x - 100.0, y: cell.frame.origin.y)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                cell.frame = CGRect(x: cellPosition.x, y: cellPosition.y, width: cell.frame.size.width, height: cell.frame.size.height)
            }, completion: nil)
        }
        
        if (gesture.direction == .right) {
            
            if (cell.frame.origin.x < (collectionView?.frame.origin.x)!) {
                let cellPosition = CGPoint(x: cell.frame.origin.x + 100.0, y: cell.frame.origin.y)
                deleteIndexPath = nil
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    cell.frame = CGRect(x: cellPosition.x, y: cellPosition.y, width: cell.frame.size.width, height: cell.frame.size.height)
                    self.deleteButton.removeFromSuperview()
                }, completion: nil)
            }
            
        }
    }
    
    var deleteIndexPath: IndexPath?
    func handleDeleteInstruction() {
        guard let deleteIndexPath = deleteIndexPath else {
            return
        }
        
        guard let cell = collectionView?.cellForItem(at: deleteIndexPath) else {
            return
        }
        
        let cellPosition = CGPoint(x: cell.frame.origin.x + 100.0, y: cell.frame.origin.y)
        cell.frame = CGRect(x: cellPosition.x, y: cellPosition.y, width: cell.frame.size.width, height: cell.frame.size.height)
        
        deleteButton.removeFromSuperview()
        ingredients.remove(at: deleteIndexPath.item)
        
        collectionView?.performBatchUpdates({
            
            self.collectionView?.deleteItems(at: NSArray(object: deleteIndexPath) as [AnyObject] as! [IndexPath])
            
        }, completion: {
            (finished: Bool) in
            
            self.collectionView?.reloadItems(at: self.collectionView!.indexPathsForVisibleItems)
            
        })
        self.deleteIndexPath = nil
    }
    
    func handleCancel() {
        self.searchController.searchResultsController?.view.removeObserver(self, forKeyPath: "hidden", context: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleDone() {
        if let parentView: EditRecipeController = parentView as? EditRecipeController {
            parentView.ingredients = ingredients
            parentView.ingredientsCollectionViewReloadData(newHeight: (collectionView?.contentSize.height)! - 44)
        }
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

}

extension EditIngredientsController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
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
