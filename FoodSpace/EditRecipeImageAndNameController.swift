//
//  EditRecipeImageAndNameController.swift
//  FoodSpace
//
//  Created by Corey Howell on 11/8/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class EditRecipeImageAndNameController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var parentView: UIViewController?
    var image: UIImage?
    var recipeTitle: NSAttributedString?
    
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
    
    let emptyView: UIView = {
        let ev = UIView()
        ev.backgroundColor = .lightGray
        ev.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageOptionActionSheet)))
        return ev
    }()
    
    lazy var mainImageView: UIImageView = {
        let iv = UIImageView()
        if let image = self.image {
            iv.image = image
        }
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = ColorPalette.BrandLightGrey
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageOptionActionSheet)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var mainTitleTextView: BaseTextView = {
        let tv = BaseTextView()
        tv.textColor = .black
        tv.backgroundColor = .clear
        tv.font = BaseTextView.Fonts.largeLightFont
        if let recipeTitle = self.recipeTitle {
            tv.attributedText = recipeTitle
        }
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isUserInteractionEnabled = true
        tv.textContainer.maximumNumberOfLines = 2
        tv.textContainer.lineBreakMode = .byTruncatingTail
        tv.isEditable = true
        tv.textAlignment = .center
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentView()
        setupNav()
        setupMainImageView()
        setupTitleTextView()
        
        setupViewResizerOnKeyboardShown()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    // MARK: - Initial Views Setup
    
    func setupContentView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        contentView.anchorToTop(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        scrollView.delegate = self
        
        contentView.addSubview(emptyView)
        emptyView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
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
    
    func setupMainImageView() {
        contentView.addSubview(mainImageView)
        mainImageView.anchorToTop(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor)
        mainImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
    }
    
    func setupTitleTextView() {
        let navHeight = (navigationController?.navigationBar.frame.origin.y)! + (navigationController?.navigationBar.frame.height)!
        contentView.addSubview(mainTitleTextView)
        mainTitleTextView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor).isActive = true
        mainTitleTextView.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor, constant: -navHeight).isActive = true
        mainTitleTextView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        mainTitleTextView.widthAnchor.constraint(lessThanOrEqualTo: mainImageView.widthAnchor).isActive = true
        mainTitleTextView.delegate = self
        mainTitleTextView.returnKeyType = UIReturnKeyType.done
        
        
        mainTitleTextView.addBottomBorderWithColor(color: .white, andWidth: 2)
        mainTitleTextView.attributedText = addStrokeToString(text: mainTitleTextView.text)
    }
    
    // MARK: TextView Delegate Methods

    
    func textViewDidChange(_ textView: UITextView) {
        let selectedRange = textView.selectedRange
        let text = textView.text
        
        let attributedString = addStrokeToString(text: text!)
        
        textView.attributedText = attributedString
        textView.selectedRange = selectedRange
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (textView.text == "Enter a name...") {
            textView.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "" || textView.text == " ") {
            textView.text = "Enter a name..."
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func addStrokeToString(text: String) -> NSMutableAttributedString {
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor.darkGray
        textShadow.shadowBlurRadius = 1.5
        textShadow.shadowOffset = CGSize.zero
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        return NSMutableAttributedString(string: text, attributes: [NSFontAttributeName: BaseTextView.Fonts.largeLightFont!, NSForegroundColorAttributeName: UIColor.white, NSShadowAttributeName: textShadow, NSStrokeColorAttributeName: UIColor.darkGray, NSStrokeWidthAttributeName: -0.3, NSParagraphStyleAttributeName: paragraphStyle])
    }
    
    // MARK: ImagePicker Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            mainImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Image Picking Options Action Sheet
    
    func imageOptionActionSheet() {
        let alert = UIAlertController(title: nil, message: "Add a photo to your recipe", preferredStyle: .actionSheet)
        
        let takeAPhoto = UIAlertAction(title: "Take A Photo", style: .default, handler: handleEditImage)
        let uploadFromCameraRoll = UIAlertAction(title: "Upload From Camera Roll", style: .default, handler: handleEditImage)
        let LetUsProvideOne = UIAlertAction(title: "Let Us Provide One", style: .default, handler: handleEditImage)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(takeAPhoto)
        alert.addAction(uploadFromCameraRoll)
        alert.addAction(LetUsProvideOne)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Handler Methods
    
    func handleEditImage (alertAction: UIAlertAction!) -> Void {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = false
        
        if alertAction.title == "Take A Photo" {
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Navigation Handlers
    
    func handleCancel() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func handleDone() {
        if let parentView: EditRecipeController = parentView as? EditRecipeController {
            parentView.mainImageView.image = mainImageView.image
            parentView.mainImageText.attributedText = mainTitleTextView.attributedText
        }
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

}
