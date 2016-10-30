//
//  IngredientDetailController.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/29/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class IngredientDetailController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var detailIngredient: Ingredient? {
        didSet {
            titleLabel.text = detailIngredient?.name
            render()
        }
    }
    
    var hasAdd: Bool = false
    
    let methodArray = ["cubed", "chopped", "sliced"]
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.addBottomBorderWithColor(color: ColorPalette.BrandLightGrey, andWidth: 1)
        label.font = BaseTextView.Fonts.smallBoldFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let unitField: UITextField = {
        let tf = UITextField()
        tf.font = BaseTextView.Fonts.smallRegularFont
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.placeholder = "Unit of measure"
        tf.tag = 200
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let unitPickerSpace: UIView = {
        let view = UIView()
        view.addBottomBorderWithColor(color: ColorPalette.BrandLightGrey, andWidth: 1)
        view.backgroundColor = .white
        view.tag = 202
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let unitPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 201
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let quantityField: UITextField = {
        let tf = UITextField()
        tf.font = BaseTextView.Fonts.smallRegularFont
        tf.allowsEditingTextAttributes = false
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.placeholder = "Quantity"
        tf.tag = 300
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let quantityPickerSpace: UIView = {
        let view = UIView()
        view.addBottomBorderWithColor(color: ColorPalette.BrandLightGrey, andWidth: 1)
        view.backgroundColor = .white
        view.tag = 302
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let quantityPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 301
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let methodField: UITextField = {
        let tf = UITextField()
        tf.font = BaseTextView.Fonts.smallRegularFont
        tf.allowsEditingTextAttributes = false
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.placeholder = "Method"
        tf.tag = 400
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let methodPickerSpace: UIView = {
        let view = UIView()
        view.addBottomBorderWithColor(color: ColorPalette.BrandLightGrey, andWidth: 1)
        view.backgroundColor = .white
        view.tag = 402
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let methodPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 401
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var unitPickerSpaceHeightAnchor: NSLayoutConstraint?
    var quantityPickerSpaceHeightAnchor: NSLayoutConstraint?
    var methodPickerSpaceHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        quantityPickerView.delegate = self
        quantityPickerView.dataSource = self
        methodPickerView.delegate = self
        methodPickerView.dataSource = self

        
        unitField.delegate = self
        unitField.inputView = unitPickerView
        quantityField.delegate = self
        quantityField.inputView = quantityPickerView
        methodField.delegate = self
        methodField.inputView = methodPickerView
        
        view.backgroundColor = .white
    }
    
    func render() {
        // this view really doesn't draw anything onto itself until the ingredient is set.
        // so anything that needs to be done visually has to be done here in render
        // and not in view did load. do not use viewWillAppear.
        
        setupNavBar()
        
        view.addSubview(titleLabel)
        titleLabel.anchorWithConstantsToTop(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        
        view.addSubview(unitField)
        unitField.anchorWithConstantsToTop(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        view.addSubview(unitPickerSpace)
        unitPickerSpace.anchorWithConstantsToTop(top: unitField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        unitPickerSpaceHeightAnchor = unitPickerSpace.heightAnchor.constraint(equalToConstant: 1)
        unitPickerSpaceHeightAnchor?.isActive = true
        
        unitPickerSpace.addSubview(unitPickerView)
        unitPickerView.topAnchor.constraint(equalTo: unitPickerSpace.topAnchor).isActive = true
        unitPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        unitPickerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        view.addSubview(quantityField)
        quantityField.anchorWithConstantsToTop(top: unitPickerSpace.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        view.addSubview(quantityPickerSpace)
        quantityPickerSpace.anchorWithConstantsToTop(top: quantityField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        quantityPickerSpaceHeightAnchor = quantityPickerSpace.heightAnchor.constraint(equalToConstant: 1)
        quantityPickerSpaceHeightAnchor?.isActive = true
        
        quantityPickerSpace.addSubview(quantityPickerView)
        quantityPickerView.topAnchor.constraint(equalTo: quantityPickerSpace.topAnchor).isActive = true
        quantityPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        quantityPickerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        view.addSubview(methodField)
        methodField.anchorWithConstantsToTop(top: quantityPickerSpace.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        view.addSubview(methodPickerSpace)
        methodPickerSpace.anchorWithConstantsToTop(top: methodField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        methodPickerSpaceHeightAnchor = methodPickerSpace.heightAnchor.constraint(equalToConstant: 1)
        methodPickerSpaceHeightAnchor?.isActive = true
        
        methodPickerSpace.addSubview(methodPickerView)
        methodPickerView.topAnchor.constraint(equalTo: methodPickerSpace.topAnchor).isActive = true
        methodPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        methodPickerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white], for: .normal)
        
        if hasAdd {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([
                NSForegroundColorAttributeName : UIColor.white], for: .normal)
        }
        
        navigationItem.title = "Recipes"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 20)!
        ]
        
        navigationController?.navigationBar.barTintColor = ColorPalette.BrandGreen
        navigationController?.navigationBar.backgroundColor = ColorPalette.BrandGreen
        
        
        edgesForExtendedLayout = []
    }
    
    func renderUnitPicker() {
        
        let height = unitPickerView.frame.height
        unitPickerSpaceHeightAnchor?.constant = height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func closeUnitPicker() {
        unitPickerSpaceHeightAnchor?.constant = 1
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func renderQuantityPicker() {
        
        let height = quantityPickerView.frame.height
        quantityPickerSpaceHeightAnchor?.constant = height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func closeQuantityPicker() {
        quantityPickerSpaceHeightAnchor?.constant = 1
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func renderMethodPicker() {
        
        let height = methodPickerView.frame.height
        methodPickerSpaceHeightAnchor?.constant = height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func closeMethodPicker() {
        methodPickerSpaceHeightAnchor?.constant = 1
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closeUnitPicker()
        closeQuantityPicker()
        closeMethodPicker()
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleAdd() {
        guard let detailIngredient = detailIngredient else {
            return
        }
        
        if let newUnit: String = unitField.text {
            detailIngredient.unit = newUnit
        }
        
        var total: Double = 0
        if !quantityWholeNumberString.isEmpty {
            total = Double(quantityWholeNumberString)!
        }
        
        if !quantityFractionString.isEmpty {
            if let fraction = Quantities.findFractionEnumFromFractionString(fractionAsString: quantityFractionString) {
                total += fraction.rawValue
            }
        }
        
        detailIngredient.quantity = total
        
        if let newMethod = methodField.text {
            detailIngredient.method = newMethod
        }
        
        
        
        if let newRecipeIngredientNavSearchController: UINavigationController = presentingViewController as? UINavigationController {
            
            if let newRecipeController: RecipeController = newRecipeIngredientNavSearchController.topViewController as? RecipeController {
                DispatchQueue.main.async(execute: {
                    guard let detailIngredient = self.detailIngredient else {
                        return
                    }
                    
                    newRecipeController.searchController.isActive = false
                    newRecipeController.ingredients.append(detailIngredient)
                    newRecipeController.tableView.reloadData()
                    newRecipeController.ingredientTableHeightAnchor?.constant = newRecipeController.tableView.contentSize.height + (CGFloat(newRecipeController.ingredients.count) * CGFloat(10))
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == quantityPickerView {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == unitPickerView {
            return Quantities.unitsStringArray.count
        }
        
        if pickerView == quantityPickerView {
            
            if component == 0 {
                return Quantities.zeroToHundredStringArray.count
            }
            
            if component == 1 {
                let allFractions = Quantities.getAllFractionsStringArray()
                return allFractions.count
            }
        }
        
        if pickerView == methodPickerView {
            return methodArray.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == unitPickerView {
            return Quantities.unitsStringArray[row]
        }
        
        if pickerView == quantityPickerView {
            
            if component == 0 {
                return Quantities.zeroToHundredStringArray[row]
            }
            
            if component == 1 {
                var allFractions = Quantities.getAllFractionsStringArray()
                return allFractions[row]
            }
        }
        
        if pickerView == methodPickerView {
            return methodArray[row]
        }
        
        return ""
    }
    
    var quantityWholeNumberString = ""
    var quantityFractionString = ""
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == unitPickerView {
            unitField.text = Quantities.unitsStringArray[row]
        }
        
        if pickerView == quantityPickerView {
            
            if component == 0 {
                quantityWholeNumberString = Quantities.zeroToHundredStringArray[row]
            }
            
            if component == 1 {
                var allFractions = Quantities.getAllFractionsStringArray()
                quantityFractionString = allFractions[row]
            }
            
            quantityField.text = "\(quantityWholeNumberString) \(quantityFractionString)"
        }
        
        if pickerView == methodPickerView {
            methodField.text = methodArray[row]
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == unitField {
            closeQuantityPicker()
            closeMethodPicker()
            
            renderUnitPicker()
        }
        
        if textField == quantityField {
            closeUnitPicker()
            closeMethodPicker()
            
            renderQuantityPicker()
        }
        
        if textField == methodField {
            closeUnitPicker()
            closeQuantityPicker()
            
            renderMethodPicker()
        }
        return false
    }
    
}
