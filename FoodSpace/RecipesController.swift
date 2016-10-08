//
//  RecipesController.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/28/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit
import Popover

class RecipesController: UIViewController {
    
    let addMenu: UIView = {
        let uv = UIView()
        uv.backgroundColor = ColorPalette.BrandGreen
        return uv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        // if there are no recipes
        createEmptyView()
        
        setupMenuBar()
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(handleAddRecipe))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 30)!
            ], for: .normal)
        
        navigationItem.title = "Recipes"
        
        let defaultFontSize = navigationController?.navigationBar.titleTextAttributes?[NSFontAttributeName]
        
        print(defaultFontSize);
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 20)!
        ]
        
        navigationController?.navigationBar.barTintColor = ColorPalette.BrandGreen
        navigationController?.navigationBar.backgroundColor = ColorPalette.BrandGreen
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
        menuBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
    }
    
    var displayingPopover: Popover?
    
    func handleAddRecipe(sender: AnyObject?) {
        // https://github.com/corin8823/Popover
        // this is weird but we need the x and y of the bar button that was touched
        guard let buttonView: UIView = sender?.view else {
            print("fail")
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
        print("presentAddRecipeModal")
        displayingPopover?.dismiss()
        
        
        let newRecipeController = NewRecipeController()
        let navController = UINavigationController(rootViewController: newRecipeController)
        present(navController, animated: true, completion: nil)
    }
    
    private func createEmptyView() {
        let emptyView: UIView = {
            let v = UIView()
            v.backgroundColor = .white
            return v
        }()
        
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
        
        view.addSubview(emptyView)
        emptyView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        emptyView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        emptyView.addSubview(textView)
        textView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
    }

}
















