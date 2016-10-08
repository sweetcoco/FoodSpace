//
//  HomeController.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/16/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let titleView: BaseTextView = {
        let tv = BaseTextView()
        return tv
    }()
    
    let newMealPlanImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "quickaction")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var mealPlans = [MealPlan]()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    let cellId = "cellId"
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        view.backgroundColor = ColorPalette.BrandWhite
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        self.navigationController?.isNavigationBarHidden = true
        setupTitleView()
        view.addSubview(collectionView)
        setupNewMealPlanImageView()
        
        let mealPlanOne = MealPlan()
        mealPlanOne.id = "1"
        mealPlanOne.ingredientCount = 18
        mealPlanOne.recipeCount = 3
        mealPlanOne.title = "Paleo Week"
        mealPlanOne.prepTime = 1.4
        mealPlans.append(mealPlanOne)
        
        let mealPlanTwo = MealPlan()
        mealPlanTwo.id = "2"
        mealPlanTwo.ingredientCount = 35
        mealPlanTwo.recipeCount = 9
        mealPlanTwo.title = "Whole 30"
        mealPlanTwo.prepTime = 4.5
        mealPlans.append(mealPlanTwo)
        
        let mealPlanThree = MealPlan()
        mealPlanThree.id = "3"
        mealPlanThree.ingredientCount = 9
        mealPlanThree.recipeCount = 11
        mealPlanThree.title = "Protein Gainy Q's"
        mealPlanThree.prepTime = 12.3
        mealPlans.append(mealPlanThree)
        
//        let mealPlanFour = MealPlan()
//        mealPlanFour.id = "4"
//        mealPlanFour.ingredientCount = 1097
//        mealPlanFour.recipeCount = 556
//        mealPlanFour.title = "Ice Cream We Scream Woo Wee!"
//        mealPlanFour.prepTime = 97654
//        mealPlans.append(mealPlanFour)
        
        
        
        
        
        collectionView.anchorWithConstantsToTop(top: newMealPlanImage.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: view.frame.height * 0.07, rightConstant: 0)
        
        //collectionView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: menuBar.topAnchor, right: view.rightAnchor)
        
        collectionView.register(MealPlanCell.self, forCellWithReuseIdentifier: cellId)
        
        setupMenuBar()
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.currentViewController = self
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        menuBar.currentMenuIndex = 0
        
        
        menuBar.anchorToTop(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        menuBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
    }
    
    func setupTitleView() {
        let thin = "create your\nfood"
        let bold = "space"
        
        let text = UIView().thinBoldThinAttributedString(thin: thin, bold: bold, secondThin: nil, size: 40, color: ColorPalette.BrandGreen)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let length = text.string.characters.count
        
        text.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
        
        titleView.attributedText = text
        
        
        view.addSubview(titleView)
        titleView.anchorWithConstantsToTop(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: view.getStatusBarHeight(), leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        titleView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
    }
    
    func setupNewMealPlanImageView() {
        view.addSubview(newMealPlanImage)
        
        newMealPlanImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newMealPlanImage.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20).isActive = true
        newMealPlanImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newMealPlanImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupMealPlanCollection(user: user)
            }
            
            }, withCancel: nil)
    }
    
    func setupMealPlanCollection(user: User) {
        //navigationItem.title = user.name
        
        observeMealPlans()
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let onboardingController = OnboardingViewController()
        
        onboardingController.homeController = self
        
        
        present(onboardingController, animated: true, completion: nil)
        
    }
    
    
    func observeMealPlans() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        // db > meal_plans table > user id
        let ref = FIRDatabase.database().reference().child("meal_plans").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let mealPlan = MealPlan()
                mealPlan.setValuesForKeys(dictionary)
                
                self.mealPlans.append(mealPlan)
                
                self.mealPlans = self.mealPlans.sorted(by: { (mealPlan1, mealPlan2) -> Bool in
                    return (mealPlan1.timestamp?.intValue)! > (mealPlan2.timestamp?.intValue)!
                })
                
                //this will crash because of background thread, so lets call this on dispatch_async main thread
                DispatchQueue.main.async(execute: { 
                    // reload the collection
                })
            }
            
            }, withCancel: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! MealPlanCell
        
        cell.mealPlan = mealPlans[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 16, height: view.frame.height * 0.15)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 50
//    }
    
    
    
    
    
    
    

}
