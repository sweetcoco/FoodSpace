//
//  CustomTabBarController.swift
//  FoodSpace
//
//  Created by Corey Howell on 11/10/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit
import Firebase

class CustomTabBarController: UITabBarController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecipesController()
        setupHomeController()
        setupGroceryListController()
        setupSettingsController()
        
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleDisplayLogin), with: nil, afterDelay: 0)
        }
    }
    
    func handleDisplayLogin() {
        let onboardingController = OnboardingViewController()
        
        //onboardingController.homeController = self
        
        present(onboardingController, animated: true, completion: nil)
    }
    
    func fetchUser() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let _user = User()
                _user.setValuesForKeys(dictionary)
                self.user = _user
            }
            
        }, withCancel: nil)
    }
    
    func setupRecipesController() {
        let recipesController = RecipesController()
        let recipesNavController = UINavigationController(rootViewController: recipesController)
//        recipesNavController.tabBarItem.title = "recipes"
//        recipesNavController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: ColorPalette.BrandGreen], for: .normal)
        recipesNavController.tabBarItem.image = UIImage(named: "recipe")
        recipesNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        viewControllers = [recipesNavController]
    }
    
    func setupHomeController() {
        let homeController = UIViewController()
        let homeNavController = UINavigationController(rootViewController: homeController)
//        homeNavController.tabBarItem.title = "home"
//        homeNavController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: ColorPalette.BrandGreen], for: .normal)
        homeNavController.tabBarItem.image = UIImage(named: "home")
        homeNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        viewControllers?.append(homeNavController)
    }
    
    func setupGroceryListController() {
        let groceryListController = UIViewController()
        let groceryListNavController = UINavigationController(rootViewController: groceryListController)
//        groceryListNavController.tabBarItem.title = "home"
//        groceryListNavController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: ColorPalette.BrandGreen], for: .normal)
        groceryListNavController.tabBarItem.image = UIImage(named: "grocery-list")
        groceryListNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        viewControllers?.append(groceryListNavController)
    }
    
    func setupSettingsController() {
        let settingsController = SettingsController()
        let settingsNavController = UINavigationController(rootViewController: settingsController)
//        settingsNavController.tabBarItem.title = "home"
//        settingsNavController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: ColorPalette.BrandGreen], for: .normal)
        settingsNavController.tabBarItem.image = UIImage(named: "settings")
        settingsNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        viewControllers?.append(settingsNavController)
    }
}
