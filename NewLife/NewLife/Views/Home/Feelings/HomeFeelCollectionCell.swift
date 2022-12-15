//
//  HomeFeelCollectionCell.swift
//  Tawazon
//
//  Created by Shadi on 15/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class HomeFeelCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    var data: SubfeelingCellModel? {
        didSet {
            populateData()
        }
    }
    
    private var cellColor: UIColor {
        if data?.isSelected ?? false {
            return .white
        } else {
            return  .clear
        }
    }
    
    private var borderWidth: CGFloat {
        if data?.isSelected ?? false {
            return 0
        } else {
            return 2
        }
    }
    
    private var textColor: UIColor {
        if data?.isSelected ?? false {
            return .metallicBlue
        } else {
            return .white
        }
    }
    
    private var borderColor: UIColor {
        return .init(white: 1.0, alpha: 0.8)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        layer.masksToBounds = true
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    func updateStyle() {
        layer.cornerRadius = frame.height / 2.0
        backgroundColor = cellColor
        titleLabel.textColor = textColor
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    private func populateData() {
        titleLabel.text = data?.name ?? ""
        updateStyle()
    }
}
