//
//  LoginCell.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/27/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit
import Firebase

class LoginCell: UICollectionViewCell, UITextFieldDelegate {
    
    var isLogin: Bool? {
        didSet {
            guard let isLogin = isLogin else {
                return
            }
            toggleButton.setTitle(isLogin ? "signup" : "login", for: .normal)
            createTitle()
            render()
        }
    }
    
    var parent: UIViewController?
    
    
    let titleView: BaseTextView = {
        let tv = BaseTextView()
        return tv
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "name"
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "Lato-Light", size: 20)
        tf.layer.cornerRadius = 3
        tf.layer.masksToBounds = true
        tf.layer.borderColor = ColorPalette.BrandGreen.cgColor
        tf.layer.borderWidth = 1
        tf.keyboardType = .default
        tf.tag = 100
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "email"
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "Lato-Light", size: 20)
        tf.layer.cornerRadius = 3
        tf.layer.masksToBounds = true
        tf.layer.borderColor = ColorPalette.BrandGreen.cgColor
        tf.layer.borderWidth = 1
        tf.keyboardType = .emailAddress
        tf.tag = 200
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "Lato-Light", size: 20)
        tf.layer.cornerRadius = 3
        tf.layer.masksToBounds = true
        tf.layer.borderColor = ColorPalette.BrandGreen.cgColor
        tf.layer.borderWidth = 1
        tf.isSecureTextEntry = true
        tf.tag = 300
        return tf
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton()
        let highlightedBackgroundImage = UIImage.fromColor(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2))
        button.backgroundColor = ColorPalette.BrandGreen
        button.titleLabel!.font =  UIFont(name: "Lato-Light", size: 25)
        button.setTitle("continue", for: .normal)
        button.setBackgroundImage(highlightedBackgroundImage, for: .highlighted)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 8, right: 10)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let toggleButton: UIButton = {
        let button = UIButton()
        let highlightedBackgroundImage = UIImage.fromColor(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2))
        button.backgroundColor = UIColor.clear
        button.titleLabel!.font =  UIFont(name: "Lato-Light", size: 25)
        button.setBackgroundImage(highlightedBackgroundImage, for: .highlighted)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.setTitleColor(ColorPalette.BrandGreen, for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        toggleButton.addTarget(self, action: #selector(self.toggleButtonClicked), for: .touchUpInside)
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegisterButton), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
    func toggleButtonClicked() {
        if isLogin == true {
            isLogin = false
        } else {
            isLogin = true
        }
    }
    
    func createTitle() {
        let attributedText = UIView().thinBoldThinAttributedString(thin: isLogin! ? "enter " : "create ", bold: "your space", secondThin: nil, size: 40, color: ColorPalette.BrandGreen)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let length = attributedText.string.characters.count
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
        
        titleView.attributedText = attributedText
    }
    
    func renderTitleView() {
        addSubview(titleView)
        
        _ = titleView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -200, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
        titleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func renderTextFields() {
        if isLogin == false {
            addSubview(nameTextField)
            
            _ = nameTextField.anchor(titleView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 40, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        }
        
        addSubview(emailTextField)
        addSubview(passwordTextField)
        
        _ = emailTextField.anchor(isLogin! ? titleView.bottomAnchor : nameTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: isLogin! ? 40 : 8, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        _ = passwordTextField.anchor(emailTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
    }
    
    func renderLoginRegisterButton() {
        addSubview(loginRegisterButton)
        
        _ = loginRegisterButton.anchor(passwordTextField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        loginRegisterButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor, multiplier: 0.5).isActive = true
        loginRegisterButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func renderToggleButton() {
        addSubview(toggleButton)
        
        toggleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        toggleButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        
    }
    
    func render() {
        if let nameTextField = viewWithTag(100) {
            nameTextField.removeFromSuperview()
        }
        
        if let emailTextField = viewWithTag(200) {
            emailTextField.removeFromSuperview()
        }
        
        if let passwordTextField = viewWithTag(300) {
            passwordTextField.removeFromSuperview()
        }
        
        renderTitleView()
        renderTextFields()
        renderLoginRegisterButton()
        renderToggleButton()
    }
    
    
    
    func handleLoginRegisterButton() {
        endEditing(true)
        
        if isLogin == true {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            // successfully logged in our user
            // tell the onboardingViewController to dismiss itself
            guard let parent = self.parent else {
                return
            }
            var vc: UIViewController = parent
            while ((vc.presentingViewController) != nil) {
                vc = vc.presentingViewController!
                
                if let ovc = vc as? OnboardingViewController {
                    //ovc.homeController?.fetchUserAndSetupNavBarTitle()
                }
            }
            vc.dismiss(animated: false, completion: nil)
            
        })
        
    }
    
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            //successfully registered the user
            
            // get their user id
            guard let uid = user?.uid else {
                return
            }
            
            // get database connection
            let ref = FIRDatabase.database().reference()
            
            // get or create "users" table, get or create a record as the user id
            let userReference = ref.child("users").child(uid)
            // these will be columns in the record
            let values = ["name": name, "email": email]
            
            // write it to the db
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                }
                
                print("Saved user successfully into Firebase db")
                // tell the onboardingViewController to dismiss itself
                guard let parent = self.parent else {
                    return
                }
                var vc: UIViewController = parent
                while ((vc.presentingViewController) != nil) {
                    vc = vc.presentingViewController!
                    
                    if let ovc = vc as? OnboardingViewController {
                        //ovc.homeController?.fetchUserAndSetupNavBarTitle()
                    }
                }
                vc.dismiss(animated: false, completion: nil)
            })
            
        })
    }
    
    
}
