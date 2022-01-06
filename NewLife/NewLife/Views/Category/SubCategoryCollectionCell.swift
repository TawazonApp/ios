//
//  SubCategoryCollectionCell.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class SubCategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedView: GradientView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var category: SubCategoryVM? {
        didSet {
            fillData()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateStyle(isSelected: isSelected)
        }
    }
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        nameLabel.font = UIFont.kacstPen(ofSize: 18)
        nameLabel.textColor = UIColor.white
        
        selectedView.layer.cornerRadius = selectedView.frame.height/2
        selectedView.layer.masksToBounds = true
    }
    
    private func updateStyle(isSelected: Bool) {
        
        var defaultColors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        
        if let category = category {
            defaultColors = [category.cellBackgroundColor.cgColor, category.cellBackgroundColor.cgColor]
            nameLabel.textColor = category.cellTextColor
        }
        
        let colors = isSelected ? category?.gradiantColors : defaultColors
        selectedView.applyGradientColor(colors: colors ?? defaultColors, startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
    }
    
    private func fillData() {
        nameLabel.text = category?.name
    }
}
