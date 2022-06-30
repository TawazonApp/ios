//
//  SearchCategoryCollectionViewCell.swift
//  Tawazon
//
//  Created by mac on 29/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SearchCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedView: GradientView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var category: SearchCategoryVM? {
        didSet {
            fillData()
        }
    }
    
     var setSelected: Bool = false {
        didSet {
            updateStyle(isSelected: setSelected)
        }
    }
    
    var isAll: Bool = false {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        nameLabel.font = UIFont.kacstPen(ofSize: 18)
        nameLabel.textColor = UIColor.white
        
        selectedView.layer.cornerRadius = selectedView.frame.height/2
        selectedView.layer.masksToBounds = true
        
    }
    
    private func updateStyle(isSelected: Bool) {
        var defaultColors = [UIColor.white.withAlphaComponent(0.25).cgColor, UIColor.white.withAlphaComponent(0.25).cgColor]
        var gradientColors = [UIColor.bubblegum.cgColor, UIColor.lightPurple.cgColor]
        
        if let category = category {
            defaultColors = [category.cellBackgroundColor.cgColor, category.cellBackgroundColor.cgColor]
            nameLabel.textColor = category.cellTextColor
            gradientColors = category.gradiantColors
        }
        
        let colors = isSelected ? gradientColors : defaultColors
        selectedView.applyGradientColor(colors: colors , startPoint: GradientPoint.right, endPoint: GradientPoint.left)
    }
    
    private func fillData() {
        nameLabel.text = isAll ? "allSearchCategoryLabel".localized : category?.name
    }
}
