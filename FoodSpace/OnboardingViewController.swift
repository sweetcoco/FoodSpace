//
//  ViewController.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/13/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    var homeController: HomeController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = ColorPalette.BrandGreen
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        //        view.backgroundColor = .blackColor()
        return view
    }()
    
    let skipButtonView: UIButton = {
        let button = UIButton()
        let highlightedBackgroundImage = UIImage.fromColor(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2))
        button.backgroundColor = UIColor.clear
        button.titleLabel!.font =  UIFont(name: "Lato-Light", size: 25)
        button.setTitle("skip", for: .normal)
        button.setBackgroundImage(highlightedBackgroundImage, for: .highlighted)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        //        button.layer.borderWidth = 1
        //        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginButtonView: UIButton = {
        let button = UIButton()
        let highlightedBackgroundImage = UIImage.fromColor(color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2))
        button.backgroundColor = UIColor.clear
        button.titleLabel!.font =  UIFont(name: "Lato-Light", size: 25)
        button.setTitle("login", for: .normal)
        button.setBackgroundImage(highlightedBackgroundImage, for: .highlighted)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        //        button.layer.borderWidth = 1
        //        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cellId = "cellId"
    
    
    
    lazy var onboardingPages: [OnboardingPage] = {
        
        let messages = self.createOnboardingMessages()
        
        let firstPage = OnboardingPage(title: "foodspace is...", message: messages[0], imageName: "onboarding_pepper")
        
        let secondPage = OnboardingPage(title: "foodspace is..", message: messages[1], imageName: "onboarding_clock")
        
        let thirdPage = OnboardingPage(title: "foodspace is...", message: messages[2], imageName: "onboarding_bulleted_list")
        
        let fourthPage = OnboardingPage(title: "foodspace is...", message: messages[3], imageName: "onboarding_shopping_cart")
        
        return [firstPage, secondPage, thirdPage, fourthPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = self.onboardingPages.count + 1
        pc.pageIndicatorTintColor = UIColor.white
        pc.currentPageIndicatorTintColor = UIColor(white: 0.7, alpha: 1)
        pc.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    func createOnboardingMessages() -> [NSMutableAttributedString] {
        
        var messages = [NSMutableAttributedString]()
        
        let firstPageMessage = UIView().thinBoldThinAttributedString(thin: "a place to ", bold: "create\n", secondThin: "meal plans", size: 30, color: UIColor.white)
        messages.append(firstPageMessage)
        
        let secondPageMessage = UIView().thinBoldThinAttributedString(thin: "a place to\n", bold: "prepare", secondThin: nil, size: 30, color: UIColor.white)
        messages.append(secondPageMessage)
        
        let thirdPageMessage = UIView().thinBoldThinAttributedString(thin: "your ", bold: "grocery list", secondThin: nil, size: 30, color: UIColor.white)
        messages.append(thirdPageMessage)
        
        let fourthPageMessage = UIView().thinBoldThinAttributedString(thin: "your space for\n", bold: "all things food", secondThin: nil, size: 30, color: UIColor.white)
        messages.append(fourthPageMessage)
        
        return messages
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        collectionView.register(OnboardingPageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "loginCell")
        
        setupViews()
        
        skipButtonView.addTarget(self, action: #selector(presentSignupController), for: .touchUpInside)
        loginButtonView.addTarget(self, action: #selector(presentLoginController), for: .touchUpInside)
        
    }
    
    func presentSignupController() {
        let signupController = SignupController();
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(signupController, animated: false, completion: nil)
    }
    
    func presentLoginController() {
        let loginController = LoginController();
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        present(loginController, animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingPages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! OnboardingPageCell
        
        if indexPath.item < onboardingPages.count {
            let onboardingPage = onboardingPages[indexPath.item]
            
            cell.page = onboardingPage
        
            return cell
        }
        
        let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: "loginCell", for: indexPath as IndexPath)
        
        return loginCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if indexPath.item >= onboardingPages.count {
            presentSignupController()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        pageControl.currentPage = Int(collectionView.contentOffset.x / pageWidth)
    }
    
    func setupViews() {
        view.addSubview(buttonsView)
        
        buttonsView.addSubview(skipButtonView)
        buttonsView.addSubview(loginButtonView)
        
        buttonsView.addSubview(pageControl)
        
        buttonsView.anchorToTop(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        buttonsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        
        skipButtonView.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor).isActive = true
        skipButtonView.leftAnchor.constraint(equalTo: buttonsView.leftAnchor, constant: 24).isActive = true
        
        loginButtonView.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor).isActive = true
        loginButtonView.rightAnchor.constraint(equalTo: buttonsView.rightAnchor, constant: -24).isActive = true
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 180).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

}

