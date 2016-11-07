//
//  NewRecipeIngredientCell.swift
//  FoodSpace
//
//  Created by Corey Howell on 9/29/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class NewRecipeIngredientCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = BaseTextView.Fonts.smallRegularFont
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorPalette.BrandLightGrey
        label.font = BaseTextView.Fonts.smallRegularFont
        return label
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.BrandLightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 100
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorPalette.BrandLightGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        nameLabel.anchorWithConstantsToTop(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
        contentView.addSubview(subLabel)
        subLabel.anchorWithConstantsToTop(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nameLabel.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        contentView.addSubview(separatorView)
        separatorView.anchorWithConstantsToTop(top: subLabel.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: self.rightAnchor, topConstant: 5, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func createTopSeparatorView() {
        if let _topSeparatorView = viewWithTag(100) {
            _topSeparatorView.removeFromSuperview()
        }
        contentView.addSubview(topSeparatorView)
        topSeparatorView.anchorWithConstantsToTop(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 5, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        topSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
