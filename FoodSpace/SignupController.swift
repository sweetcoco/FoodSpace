//
//  LoginController.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/15/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UIViewController {
    
    let titleView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .center
        return tv
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginRegisterButton: UIButton = {
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
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error)
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
                    print(err)
                }
                
                print("Saved user successfully into Firebase db")
                // find the lowest view, and dismiss it. this will dismiss all the children too.
                var vc: UIViewController = self
                while ((vc.presentingViewController) != nil) {
                    vc = vc.presentingViewController!
                    
                    if let ovc = vc as? OnboardingViewController {
                        ovc.homeController?.fetchUserAndSetupNavBarTitle()
                    }
                }
                vc.dismiss(animated: false, completion: nil)
            })
            
        })
    }
    
    func presentHomeView() {
        let homeController = HomeController();
            
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
        present(homeController, animated: false, completion: nil)
    }
    
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
        return tf
    }()
    
    let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let loginButtonView: UIButton = {
        let button = UIButton()
        let highlightedBackgroundImage = UIImage.fromColor(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2))
        button.backgroundColor = UIColor.clear
        button.titleLabel!.font =  UIFont(name: "Lato-Light", size: 25)
        button.setTitle("login", for: .normal)
        button.setTitleColor(ColorPalette.BrandGreen, for: .normal)
        button.setBackgroundImage(highlightedBackgroundImage, for: .highlighted)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        createTitle()
        
        view.addSubview(titleView)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(buttonsView)
        
        setupInputsContainerView()
        setupTitleView()
        setupLoginRegisterButton()
        setupLoginButtonView()
        
        loginButtonView.addTarget(self, action: #selector(presentLoginController), for: .touchUpInside)
        loginRegisterButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    func createTitle() {
        let attributedText = UIView().thinBoldThinAttributedString(thin: "create ", bold: "your space", secondThin: nil, size: 40, color: ColorPalette.BrandGreen)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let length = attributedText.string.characters.count
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
        
        titleView.attributedText = attributedText
    }
    
    func presentLoginController() {
        let loginController = LoginController();
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = "flip"
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        present(loginController, animated: false, completion: nil)
    }
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(passwordTextField)
        
        //need x, y, width, height constraints
        nameTextField.anchorToTop(top: inputsContainerView.topAnchor, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor)
        nameTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        //need x, y, width, height constraints
        emailTextField.anchorToTop(top: nil, left: inputsContainerView.leftAnchor, bottom: nil, right: inputsContainerView.rightAnchor)
        emailTextField.centerYAnchor.constraint(equalTo: inputsContainerView.centerYAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.anchorToTop(top: nil, left: inputsContainerView.leftAnchor, bottom: inputsContainerView.bottomAnchor, right: inputsContainerView.rightAnchor)
        passwordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupTitleView() {
        titleView.anchorWithConstantsToTop(top: nil, left: inputsContainerView.leftAnchor, bottom: inputsContainerView.topAnchor, right: inputsContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 40, rightConstant: 0)
        titleView.heightAnchor.constraint(equalToConstant: 65).isActive = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 0.5).isActive = true
        //loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    func setupLoginButtonView() {
        buttonsView.anchorToTop(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        buttonsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        
        buttonsView.addSubview(loginButtonView)
        
        loginButtonView.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor).isActive = true
        loginButtonView.rightAnchor.constraint(equalTo: buttonsView.rightAnchor, constant: -24).isActive = true
    }
}
