//
//  OnboardingPageCell
//  FoodSpace
//
//  Created by Corey Howell on 9/13/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class OnboardingPageCell: BaseCell {
    
    var page: OnboardingPage? {
        didSet {
            
            guard let page = page else {
                return
            }
            
            imageView.image = UIImage(named: page.imageName)
            
            let _foodspaceBrandedString = foodspaceBrandedString(size: 30, color: UIColor.white)
            
            
            _foodspaceBrandedString.append(NSAttributedString(string: " is...", attributes: [NSFontAttributeName: UIFont(name: "Lato-Light", size: 30)!, NSForegroundColorAttributeName: UIColor.white]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let length = _foodspaceBrandedString.string.characters.count
            
            _foodspaceBrandedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            titleView.attributedText = _foodspaceBrandedString
            
            messageView.attributedText = page.message
            messageView.textAlignment = .center
        }
    }
    
    let titleView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = ColorPalette.BrandGreen
        iv.image = UIImage(named: "onboarding_pepper")
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let messageView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(titleView)
        addSubview(messageView)
        
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleView.anchorWithConstantsToTop(top: nil, left: leftAnchor, bottom: imageView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 0)
        titleView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        messageView.anchorWithConstantsToTop(top: imageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 30, leftConstant: 20, bottomConstant: 0, rightConstant: 20)
        messageView.heightAnchor.constraint(equalToConstant: 90).isActive = true

    }
}
