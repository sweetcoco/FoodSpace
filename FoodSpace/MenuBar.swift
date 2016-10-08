//
//  MenuBar.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/17/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class MenuBar : UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var currentViewController: UIViewController?
    var currentMenuIndex: Int? {
        didSet {
            guard let index = currentMenuIndex else {
                return
            }
            let selectedIndexPath = NSIndexPath(item: index, section: 0)
            collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.dataSource = self
        cv.delegate = self
        cv.clipsToBounds = false
        cv.isScrollEnabled = false
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["home", "recipe", "quickaction", "grocery-list", "settings"]
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        setupCollectionView()
        
        
        backgroundColor = ColorPalette.BrandLightGrey
    }
    
    func setupCollectionView() {
        collectionView.anchorToTop(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        if indexPath.item != 2 {
            cell.imageName = "\(imageNames[indexPath.item])"
            cell.highlightedImageName = "\(imageNames[indexPath.item])-selected"
            
            let image: String = (indexPath.item == currentMenuIndex! ? cell.highlightedImageName : cell.imageName)!
            
            cell.imageView.image = UIImage(named: image)
        } else {
            cell.imageView.image = UIImage(named: imageNames[indexPath.item])
        }
        cell.index = indexPath.item
        
        if indexPath.item == 2 {
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 2 {
            return CGSize(width: (frame.width / 4), height: frame.height)
        }
        
        return CGSize(width: frame.width / 5.34, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentIndex = currentMenuIndex, let currentController = currentViewController else {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (indexPath.item == 0 && currentIndex != 0) {
            appDelegate.setNewRootView(newViewController: HomeController(), oldViewController: currentController)
        }
        
        if (indexPath.item == 1 && currentIndex != 1) {
            appDelegate.setNewRootView(newViewController: RecipesController(), oldViewController: currentController)
        }
        
        if (indexPath.item == 4 && currentIndex != 4) {
            appDelegate.setNewRootView(newViewController: SettingsController(), oldViewController: currentController)
        }
    }

    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class MenuCell: BaseCell {
    
    var highlightedImageName: String?
    var imageName: String?
    
    var index: Int? {
        didSet {
            if index == 2 {
            
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                imageView.centerYAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
            } else {
                
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
                imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
                
                
                
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            // change to green icon.
            if index != 2 {
                guard let highlightedImageName = self.highlightedImageName else {
                    return
                }
                
                guard let imageName = self.imageName else {
                    return
                }
                imageView.image = isSelected ? UIImage(named: highlightedImageName) : UIImage(named: imageName)
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            // change to green icon.
            if index != 2 {
                guard let highlightedImageName = self.highlightedImageName else {
                    return
                }
                
                guard let imageName = self.imageName else {
                    return
                }
                imageView.image = isSelected ? UIImage(named: highlightedImageName) : UIImage(named: imageName)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "HOME")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = ColorPalette.BrandWhite
        return iv
    }()
    
    override func setupViews() {
        addSubview(imageView)
    }
}
