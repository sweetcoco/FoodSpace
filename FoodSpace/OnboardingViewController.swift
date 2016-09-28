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
    let loginCellId = "loginCellId"
    
    var loginCellisLogin: Bool = false
    
    
    
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
        
        observeKeyboardNotifications()
        
        view.addSubview(collectionView)
        collectionView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        registerCells()
        
        setupViews()
        
        skipButtonView.addTarget(self, action: #selector(skipButtonClicked), for: .touchUpInside)
        loginButtonView.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
    }
    
    func skipButtonClicked() {
        let indexPath = IndexPath(item: onboardingPages.count, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        loginCellisLogin = false
        
        moveControlConstraintsOffScreen()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    func loginButtonClicked() {
        let indexPath = IndexPath(item: onboardingPages.count, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        loginCellisLogin = true
        
        moveControlConstraintsOffScreen()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    fileprivate func registerCells() {
        collectionView.register(OnboardingPageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingPages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == onboardingPages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            loginCell.isLogin = loginCellisLogin
            loginCell.parent = self
            return loginCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! OnboardingPageCell
        
        let onboardingPage = onboardingPages[indexPath.item]
        cell.page = onboardingPage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonBottomAnchor: NSLayoutConstraint?
    var loginButtonBottomAnchor: NSLayoutConstraint?
    
    func setupViews() {
        view.addSubview(pageControl)
        
        view.addSubview(skipButtonView)
        view.addSubview(loginButtonView)
        
        skipButtonBottomAnchor = skipButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        skipButtonBottomAnchor?.isActive = true
        skipButtonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        
        loginButtonBottomAnchor = loginButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        loginButtonBottomAnchor?.isActive = true
        loginButtonView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 60, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: -80, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        //we are on the last page
        if pageNumber == onboardingPages.count {
            moveControlConstraintsOffScreen()
        } else {
            //back on regular pages
            pageControlBottomAnchor?.constant = -60
            skipButtonBottomAnchor?.constant = -30
            loginButtonBottomAnchor?.constant = -30
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    fileprivate func moveControlConstraintsOffScreen() {
        pageControlBottomAnchor?.constant = 140
        skipButtonBottomAnchor?.constant = 140
        loginButtonBottomAnchor?.constant = 140
    }

}










