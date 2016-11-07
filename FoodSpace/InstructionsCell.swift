//
//  InstructionsCollectionViewCell.swift
//  FoodSpace
//
//  Created by Corey Howell on 11/4/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class InstructionsCell: UICollectionViewCell {
    var instruction: String? {
        didSet {
            if let instruction = instruction {
                textView.text = instruction
            }
        }
    }
    
    var index: Int? {
        didSet {
            if let index = index {
                lineNumberLabel.text = "\(index + 1)"
            }
        }
    }
    
    var constraintConstantsSet = false
    var containerViewLeftConstant: CGFloat?
    var containerViewRightConstant: CGFloat?
    var numberViewLeftConstant: CGFloat?
    var numberViewRightConstant: CGFloat?
    var lineNumberHeight: CGFloat? {
        didSet {
            if (!constraintConstantsSet) {
                setConstraints()
                constraintConstantsSet = true
                self.layoutIfNeeded()
            }
        }
    }
    
    override var bounds : CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = nil
        tv.font = BaseTextView.Fonts.smallLightFont
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .black
        tv.textAlignment = .left
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let containerView: UIView = {
        let view = UIView()
        //view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let lineNumberView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.BrandGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    let lineNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = BaseTextView.Fonts.smallLightFont
        label.backgroundColor = .clear
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.addSubview(lineNumberView)
        lineNumberView.addSubview(lineNumberLabel)
        containerView.addSubview(textView)
        
    }
    
    func setConstraints() {
        guard let containerViewLeftConstant = containerViewLeftConstant,
            let containerViewRightConstant = containerViewRightConstant,
            let numberViewLeftConstant = numberViewLeftConstant,
            let numberViewRightConstant = numberViewRightConstant,
            let lineNumberHeight = lineNumberHeight else {
                print("something is nil")
                return
        }
            
        containerView.anchorWithConstantsToTop(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: containerViewLeftConstant, bottomConstant: 0, rightConstant: containerViewRightConstant)
        
        lineNumberView.anchorWithConstantsToTop(top: nil, left: containerView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: numberViewLeftConstant, bottomConstant: 10, rightConstant: numberViewRightConstant)
        
        lineNumberView.heightAnchor.constraint(equalToConstant: lineNumberHeight).isActive = true
        lineNumberView.widthAnchor.constraint(equalToConstant: lineNumberHeight).isActive = true
        lineNumberView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        lineNumberLabel.anchorWithConstantsToTop(top: lineNumberView.topAnchor, left: lineNumberView.leftAnchor, bottom: lineNumberView.bottomAnchor, right: lineNumberView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10)
        
        textView.anchorToTop(top: nil, left: lineNumberView.rightAnchor, bottom: nil, right: containerView.rightAnchor)
        textView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        textView.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineNumberView.layer.cornerRadius = lineNumberView.bounds.size.width/2
        //containerView.addTopBorderWithColor(color: .lightGray, andWidth: 1)
        containerView.addBottomBorderWithColor(color: .lightGray, andWidth: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
