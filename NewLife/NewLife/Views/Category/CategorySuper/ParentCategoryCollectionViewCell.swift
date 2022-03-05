//
//  ParentCategoryCollectionViewCell.swift
//  Tawazon
//
//  Created by mac on 02/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class ParentCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectedView: GradientView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var selectedCellBackgroundImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
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
        title.font = UIFont.kacstPen(ofSize: 18)
        title.textColor = UIColor.white
        
        selectedView.layer.cornerRadius = selectedView.frame.height/2
        selectedView.layer.masksToBounds = true
    }
    private func fillData() {
        categoryImage.image = UIImage(named: "")
        title.text = category?.name
        selectedCellBackgroundImage.image = UIImage(named: "")
        selectedCellBackgroundImage.isHidden = true
        
    }
    private func updateStyle(isSelected: Bool) {
        
        var defaultColors = [UIColor.midnightExpress.cgColor]
        
//        if let category = category {
//            defaultColors = [category.cellBackgroundColor.cgColor, category.cellBackgroundColor.cgColor]
//            title.textColor = category.cellTextColor
//        }
        
        let colors = isSelected ? category?.gradiantColors : defaultColors
        selectedView.applyGradientColor(colors: colors ?? defaultColors, startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        selectedCellBackgroundImage.isHidden = !isSelected
    }
}
