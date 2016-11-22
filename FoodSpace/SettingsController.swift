//
//  SettingsController.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/18/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit
import Firebase

class SettingsController: UIViewController {
    
    let contentView: UIView = {
        let cv = UIView()
        
        return cv
    }()
    
    lazy var buttonView: UIButton = {
        let bv = UIButton()
        let highlightedBackgroundImage = UIImage.fromColor(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2))
        bv.setTitle("logout", for: .normal)
        bv.titleLabel?.font = UIFont(name: "Lato-Light", size: 20)
        bv.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.setTitleColor(UIColor.white, for: .normal)
        bv.backgroundColor = ColorPalette.BrandCloudy
        bv.setBackgroundImage(highlightedBackgroundImage, for: .highlighted)
        return bv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorPalette.BrandWhite
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        self.navigationController?.isNavigationBarHidden = true
        
        view.addSubview(contentView)
        contentView.addSubview(buttonView)
        
        contentView.anchorWithConstantsToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: view.frame.height * 0.07, rightConstant: 0)
        
        buttonView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        buttonView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //setupMenuBar()
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.currentViewController = self
        mb.currentMenuIndex = 4
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        
        
        menuBar.anchorToTop(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        menuBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // home controller has a method that checks if the user is logged in... this is hacky and shitty
        appDelegate.setNewRootView(newViewController: CustomTabBarController(), oldViewController: self)
        
    }

}
