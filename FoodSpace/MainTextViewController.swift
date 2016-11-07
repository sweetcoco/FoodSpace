//
//  MainTextViewController.swift
//  FoodSpace
//
//  Created by Corey Howell on 11/3/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class MainTextViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    var parentView: UIViewController?
    var placeholder: String?
    
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
    
    let mainTextView: BaseTextView = {
        let tv = BaseTextView()
        tv.textColor = .black
        tv.isEditable = true
        tv.font = BaseTextView.Fonts.smallLightFont
        tv.backgroundColor = .white
        tv.isUserInteractionEnabled = true
        return tv
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = BaseTextView.Fonts.smallLightFont
        label.sizeToFit()
        label.textColor = .lightGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        setupNav()
        setupMainTextView()
        
        setupViewResizerOnKeyboardShown()
    }
    
    override func viewDidLayoutSubviews() {
        mainTextView.becomeFirstResponder()
    }
    
    // MARK: - Initial Views Setup
    
    func setupContentView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        contentView.anchorToTop(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        scrollView.delegate = self
    }
    
    func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white], for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white], for: .normal)
        
        navigationItem.title = "Recipe"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 20)!
        ]
        
        navigationController?.navigationBar.barTintColor = ColorPalette.BrandGreen
        navigationController?.navigationBar.backgroundColor = ColorPalette.BrandGreen
        
        edgesForExtendedLayout = []
    }
    
    func setupMainTextView() {
        if mainTextView.text == placeholder {
            mainTextView.text = ""
        }
        
        contentView.addSubview(mainTextView)
        mainTextView.anchorToTop(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        
        mainTextView.addSubview(placeholderLabel)
        
        if let placeholderText = placeholder {
            placeholderLabel.text = placeholderText
        }
        
        placeholderLabel.anchorWithConstantsToTop(top: mainTextView.topAnchor, left: mainTextView.leftAnchor, bottom: nil, right: mainTextView.rightAnchor, topConstant: 10, leftConstant: 5, bottomConstant: 0, rightConstant: 0)
        placeholderLabel.isHidden = !mainTextView.text.isEmpty
        
        mainTextView.delegate = self
    }
    
// MARK: - TextView Delegate Methods
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
        
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
// MARK: - Keyboard Methods
    
    var defaultViewFrame: CGRect?
    
    override func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let insets:UIEdgeInsets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0.0, keyboardSize.height, 0.0)
            
            self.scrollView.contentInset = insets
            self.scrollView.scrollIndicatorInsets = insets
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    

// MARK: - Navigation Handlers
    
    func handleCancel() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func handleDone() {
        if let parentView: EditRecipeController = parentView as? EditRecipeController {
            parentView.descriptionText.text = mainTextView.text
            parentView.descriptionText.textColor = .black
            
            if (mainTextView.text.isEmpty) {
                parentView.descriptionText.text = placeholder
                parentView.descriptionText.textColor = .lightGray
            }
        }
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

}
