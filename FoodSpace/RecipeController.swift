//
//  RecipeController.swift
//  FoodSpace
//
//  Created by Corey Howell on 10/18/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit
import Firebase

class RecipeController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextViewDelegate {
    
    // ingredients the user has selected
    var ingredients = [Ingredient]()
    
    // ingredients on autocomplete
    var filteredIngredients = [Ingredient]()
    
    var instructions = [String]()
    var lastInstruction: BaseTextView?
    
    let cellId = "cellId"
    
    var currentState: String? { // "edit" or "view"
        didSet {
            setupNavBar()
        }
    }
    
    let contentView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        return cv
    }()

    let scrollView: BaseScrollView =  {
        let sv = BaseScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
        return sv
    }()
    

    let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "taco_example")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = ColorPalette.BrandLightGrey
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let mainImageText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = BaseTextView.Fonts.largeRegularFont
        label.text = "Chicken Dicks in Sauce"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let descriptionHeader: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = BaseTextView.Fonts.smallRegularFont
        label.text = "Description:"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextPlaceHolder = "Write a description..."
    let descriptionText: BaseTextView = {
        let tv = BaseTextView()
        tv.textColor = .black
        tv.isEditable = true
        tv.font = BaseTextView.Fonts.smallLightFont
        tv.backgroundColor = .white
        tv.isUserInteractionEnabled = true
        return tv
    }()
    
    let instructionsHeader: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = BaseTextView.Fonts.smallRegularFont
        label.text = "Cooking Instructions:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionContainer: UIView = {
        let iv = UIView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let ingredientsHeader: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = BaseTextView.Fonts.smallRegularFont
        label.text = "Ingredients Needed:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let newInstructionTextPlaceHolder = "Preheat oven to 400"
    let newInstructionText: BaseTextView = {
        let tv = BaseTextView()
        tv.textColor = .black
        tv.isEditable = true
        tv.font = BaseTextView.Fonts.smallLightFont
        tv.backgroundColor = .white
        tv.isUserInteractionEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let addIngredientImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "add_small")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    let dimmerView: UIView = {
        let dv = UIView()
        dv.backgroundColor = .black
        dv.alpha = 0.5
        return dv
    }()
    
    let footerView: UIView = {
        let fv = UIView()
        fv.backgroundColor = .white
        fv.translatesAutoresizingMaskIntoConstraints = false
        return fv
    }()

    let searchController = UISearchController(searchResultsController: NewRecipeIngredientsSearchResultsController())

    override func viewDidLoad() {
        super.viewDidLoad()
        if let window = UIApplication.shared.keyWindow {
            window.backgroundColor = .black
        }
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        contentView.anchorToTop(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        scrollView.delegate = self
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        //descriptionText.delegate = self
        
        self.searchController.searchResultsController?.view.addObserver(self, forKeyPath: "hidden", options: [], context: nil)
        
        tableView.register(NewRecipeIngredientCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        definesPresentationContext = true
        
        setupNavBar()
        
        renderMainImageView()
        renderDescription()
        renderInstructions()
        renderIngredients()
        
        
        contentView.addSubview(footerView)
        footerView.anchorToTop(top: tableView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        footerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        setupViewResizerOnKeyboardShown()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        scrollToCursorForTextView(textView: textView)
        
        if textView.text == descriptionTextPlaceHolder && textView == descriptionText {
            moveCursorToStart(textView: textView)
        }
        
        if textView.text == newInstructionTextPlaceHolder && textView == newInstructionText {
            moveCursorToStart(textView: textView)
        }
    }
    
    internal func scrollToCursorForTextView(textView: UITextView) {
        var cursorRect = textView.caretRect(for: textView.selectedTextRange!.start)
        let buffer = 0
        cursorRect = scrollView.convert(cursorRect, from: textView)
        cursorRect.origin.y += (navigationController?.navigationBar.frame.maxY)! + CGFloat(buffer)
        if !self.rectVisible(rect: cursorRect) {
            cursorRect.size.height += 8
            scrollView.scrollRectToVisible(cursorRect, animated: true)
        }
    }
    
    internal func rectVisible(rect: CGRect) -> Bool {
        var visibleRect = CGRect()
        visibleRect.origin = scrollView.contentOffset
        visibleRect.origin.y += scrollView.contentInset.top
        visibleRect.size = scrollView.bounds.size
        visibleRect.size.height -= scrollView.contentInset.top + scrollView.contentInset.bottom
        
        return rect.maxY <= visibleRect.maxY
    }
    
    var defaultViewFrame: CGRect?
    
    override func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            contentView.layoutIfNeeded()
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - (keyboardSize.height + CGFloat(doneBarHeight) + 11))
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == descriptionText {
            activateDimmerViewForDescription()
            addDoneToolbarToKeyboard(textView: textView)
            
            if textView.text == descriptionTextPlaceHolder {
                moveCursorToStart(textView: textView)
            }
        }
        
        if textView == newInstructionText {
            if textView.text == newInstructionTextPlaceHolder {
                addDoneToolbarToKeyboard(textView: textView)
                moveCursorToStart(textView: textView)
            }
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async(execute: {
            self.scrollToCursorForTextView(textView: textView)
        })
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView == descriptionText {
            deactivateDimmerViewForDescription()
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 {
            if textView == descriptionText && textView.text == descriptionTextPlaceHolder ||
                textView == newInstructionText && textView.text == newInstructionTextPlaceHolder {
                if text.utf16.count == 0 { // they hit the back button
                    return false // ignore it
                }
                applyNonPlaceholderStyle(textview: textView)
                textView.text = ""
            }
            return true
        }
        else {  // no text, so show the placeholder
            var placeHolderText = ""
            if textView == descriptionText {
                placeHolderText = descriptionTextPlaceHolder
            } else {
                placeHolderText = newInstructionTextPlaceHolder
            }
            applyPlaceholderStyle(textview: textView, placeholderText: placeHolderText)
            moveCursorToStart(textView: textView)
            return false
        }
    }
    
    func applyPlaceholderStyle(textview: UITextView, placeholderText: String) {
        // make it look (initially) like a placeholder
        textview.textColor = .lightGray
        textview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(textview: UITextView) {
        // make it look like normal text instead of a placeholder
        textview.textColor = .darkText
        textview.alpha = 1.0
    }
    
    func moveCursorToStart(textView: UITextView) {
        DispatchQueue.main.async(execute: {
            textView.selectedRange = NSMakeRange(0, 0);
        })
    }
    
    func activateDimmerViewForDescription() {
        
        contentView.bringSubview(toFront: descriptionContainer)
        contentView.insertSubview(dimmerView, belowSubview: descriptionContainer)
        dimmerView.anchorToTop(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: view.bottomAnchor, right: contentView.rightAnchor)
    }
    
    func deactivateDimmerViewForDescription() {
        dimmerView.removeFromSuperview()
    }
    
    override func keyboardWillHideForResizing(notification: Notification) {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil && defaultViewFrame != nil {
            self.view.frame = defaultViewFrame!
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil OR defaultViewFrame is not set. Now is the rapture.")
        }
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async(execute: {
            super.updateViewConstraints()
            self.ingredientTableHeightAnchor?.constant = self.tableView.contentSize.height
        })
    }
    
    override func viewDidLayoutSubviews() {
        if defaultViewFrame == nil {
            defaultViewFrame = self.view.frame
        }
    }
    
    func setupNavBar() {
        if currentState == "edit" {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
            navigationItem.leftBarButtonItem?.setTitleTextAttributes([
                NSForegroundColorAttributeName : UIColor.white], for: .normal)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([
                NSForegroundColorAttributeName : UIColor.white], for: .normal)
        }
        
        navigationItem.title = "Ingredients"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 20)!
        ]
        
        navigationController?.navigationBar.barTintColor = ColorPalette.BrandGreen
        navigationController?.navigationBar.backgroundColor = ColorPalette.BrandGreen
        
        edgesForExtendedLayout = []
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
    
    func handleCancel() {
        self.searchController.searchResultsController?.view.removeObserver(self, forKeyPath: "hidden")
        dismiss(animated: true, completion: nil)
    }
    
    func handleDone() {
        print("bbb")
    }

    func appendInstruction(instructionText: String) {
        if instructionText.characters.count < 1 {
            //return addInstruction()
        }
        
        instructions.append(instructionText);
        //renderInstructionTextViews()
    }
    
    func addIngredient() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        present(searchController, animated: true, completion: nil)
        
    }
    
    func renderMainImageView() {
        contentView.addSubview(mainImageView)
        mainImageView.anchorToTop(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor)
        mainImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        contentView.addSubview(mainImageText)
        mainImageText.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor).isActive = true
        mainImageText.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor).isActive = true
    }
    
    
    func renderDescription() {
        contentView.addSubview(descriptionContainer)
        descriptionContainer.anchorWithConstantsToTop(top: mainImageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 20, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        descriptionContainer.addSubview(descriptionHeader)
        
        descriptionHeader.anchorWithConstantsToTop(top: descriptionContainer.topAnchor, left: descriptionContainer.leftAnchor, bottom: nil, right: descriptionContainer.rightAnchor, topConstant: 1, leftConstant: 1, bottomConstant: 0, rightConstant: 1)
        
        descriptionContainer.addSubview(descriptionText)
        
        descriptionText.anchorWithConstantsToTop(top: descriptionHeader.bottomAnchor, left: descriptionContainer.leftAnchor, bottom: descriptionContainer.bottomAnchor, right: descriptionContainer.rightAnchor, topConstant: 0, leftConstant: 1, bottomConstant: 1, rightConstant: 1)
        
        descriptionText.delegate = self
        applyPlaceholderStyle(textview: descriptionText, placeholderText: descriptionTextPlaceHolder)
        
        descriptionContainer.layer.borderWidth = 2
        descriptionContainer.layer.borderColor = UIColor.white.cgColor
        descriptionContainer.layer.cornerRadius = 3
        
//        descriptionContainer.layer.shadowColor = UIColor.black.cgColor
//        descriptionContainer.layer.shadowOpacity = 0.3
//        descriptionContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
//        descriptionContainer.layer.shadowRadius = 4
    }
    
    let doneBarHeight = 50
    var doneBarAddedToTextView: UITextView?
    
    func addDoneToolbarToKeyboard(textView: UITextView) {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: doneBarHeight))
        let backgroundView = UIView()
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonClickedDismissKeyboard))
        doneButton.tintColor = .white
        backgroundView.backgroundColor = ColorPalette.BrandGreen
        doneToolbar.addSubview(backgroundView)
        backgroundView.anchorToTop(top: doneToolbar.topAnchor, left: doneToolbar.leftAnchor, bottom: doneToolbar.bottomAnchor, right: doneToolbar.rightAnchor)
        doneToolbar.barStyle = .blackTranslucent
        doneToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
        doneToolbar.sizeToFit()
        textView.inputAccessoryView = doneToolbar
        doneBarAddedToTextView = textView
    }
    
    func doneButtonClickedDismissKeyboard() {
        guard let textView = doneBarAddedToTextView else {
            return
        }
        
        if textView == newInstructionText {
            print(newInstructionText.frame.size)
        }
        doneBarAddedToTextView = nil
        UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var instructionViewBottomAnchor: NSLayoutConstraint?
    
    func renderInstructions() {
        //instructions.append("1. eat tacos");
        //instructions.append("2. fire 'em up!");
        contentView.addSubview(instructionContainer)
        instructionContainer.anchorWithConstantsToTop(top: descriptionContainer.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        instructionContainer.addSubview(instructionsHeader)
        instructionsHeader.anchorToTop(top: instructionContainer.topAnchor, left: instructionContainer.leftAnchor, bottom: nil, right: instructionContainer.rightAnchor)
        
        for instruction in instructions {
            renderInstructionTextView(instruction: instruction)
        }
        
        renderNewInstructionTextInput()
        newInstructionText.delegate = self
    }

    func renderInstructionTextView(instruction: String) {
        let instructionTextView: BaseTextView = {
            let tv = BaseTextView()
            tv.textColor = .black
            tv.isEditable = true
            tv.font = BaseTextView.Fonts.smallLightFont
            tv.backgroundColor = .white
            tv.isUserInteractionEnabled = true
            tv.text = instruction
            return tv
        }()
        
        var _topAnchor: NSLayoutYAxisAnchor?
        
        if let preceedingInstruction = lastInstruction {
            _topAnchor = preceedingInstruction.bottomAnchor
        } else {
            _topAnchor = instructionsHeader.bottomAnchor
        }
        
        guard let topAnchor = _topAnchor else {
            return
        }
        
        instructionContainer.addSubview(instructionTextView)
        instructionTextView.anchorToTop(top: topAnchor, left: instructionContainer.leftAnchor, bottom: nil, right: instructionContainer.rightAnchor)
        lastInstruction = instructionTextView
    }
    
    func renderNewInstructionTextInput() {
        var _topAnchor: NSLayoutYAxisAnchor?
        
        if let preceedingInstruction = lastInstruction {
            _topAnchor = preceedingInstruction.bottomAnchor
        } else {
            _topAnchor = instructionsHeader.bottomAnchor
        }
        
        guard let topAnchor = _topAnchor else {
            return
        }
        
        instructionContainer.addSubview(newInstructionText)
        newInstructionText.anchorToTop(top: topAnchor, left: instructionContainer.leftAnchor, bottom: instructionContainer.bottomAnchor, right: instructionContainer.rightAnchor)
        
        newInstructionText.text = newInstructionTextPlaceHolder
        newInstructionText.clipsToBounds = false
        newInstructionText.layer.cornerRadius = 3
        newInstructionText.layer.shadowColor = UIColor.black.cgColor
        newInstructionText.layer.shadowOpacity = 0.3
        newInstructionText.layer.shadowOffset = CGSize(width: 2, height: 2)
        newInstructionText.layer.shadowRadius = 4
        applyPlaceholderStyle(textview: newInstructionText, placeholderText: newInstructionTextPlaceHolder)
    }
    
    var ingredientTableHeightAnchor: NSLayoutConstraint?

    func renderIngredients() {
        contentView.addSubview(ingredientsHeader)
        ingredientsHeader.anchorWithConstantsToTop(top: instructionContainer.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        if currentState == "edit" {
            contentView.addSubview(addIngredientImage)
            addIngredientImage.anchorWithConstantsToTop(top: ingredientsHeader.topAnchor, left: nil, bottom: ingredientsHeader.bottomAnchor, right: ingredientsHeader.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 16)
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addIngredient))
            addIngredientImage.addGestureRecognizer(tap)
        }
        
        contentView.addSubview(tableView)
        tableView.anchorToTop(top: ingredientsHeader.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor)
        //tableView.anchorWithConstantsToTop(top: ingredientsHeader.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 1000, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        tableView.backgroundColor = ColorPalette.BrandLightGrey
        
        ingredientTableHeightAnchor = tableView.heightAnchor.constraint(equalToConstant: 500)
        ingredientTableHeightAnchor?.isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = ingredients.count
        
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height))
        emptyLabel.font = BaseTextView.Fonts.mediumRegularFont
        emptyLabel.textColor = ColorPalette.BrandLightGrey
        emptyLabel.numberOfLines = 2
        emptyLabel.textAlignment = .center
        
        tableView.backgroundView = emptyLabel
        tableView.separatorStyle = .none
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewRecipeIngredientCell
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.row == 0 {
            cell.createTopSeparatorView()
        }
        
        let ingredient: Ingredient
        ingredient = ingredients[indexPath.row]
        cell.nameLabel.text = ingredient.name
        var description = ""
        
        if let quantity = ingredient.quantity {
            description.append("\(Quantities.getFractionStringFromDecimal(decimal: quantity)) ")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient: Ingredient
        ingredient = ingredients[indexPath.row]
        
        print(ingredient.name)
        print(ingredient.unit)
        print(ingredient.quantity)
        print(ingredient.method)
    }
    
    var deleteIngredientIndexPath: IndexPath?
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteIngredientIndexPath = indexPath
            let ingredientToDelete = ingredients[indexPath.row]
            confirmDelete(item: ingredientToDelete.name!)
        }
    }
    
    func confirmDelete(item: String) {
        let alert = UIAlertController(title: "Delete \(item)", message: "Are you sure you want to permanently delete \(item)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteIngredient)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteIngredient)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteIngredient(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteIngredientIndexPath {
            tableView.beginUpdates()
            
            ingredients.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteIngredientIndexPath = nil
            
            tableView.endUpdates()
            ingredientTableHeightAnchor?.constant = tableView.contentSize.height + (CGFloat(ingredients.count) * CGFloat(10))
        }
    }
    
    func cancelDeleteIngredient(alertAction: UIAlertAction!) {
        deleteIngredientIndexPath = nil
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension RecipeController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let newQuery = searchController.searchBar.text!
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(filterContentForSearchText), object: nil)
        
        // now that we've cancelled the previous query, lets update the current query string.
        // we do this because if the cancel doesn't happen, we don't want to update the string yet.
        currentQuery = newQuery
        
        perform(#selector(filterContentForSearchText), with: nil, afterDelay: 1)
    }
}
