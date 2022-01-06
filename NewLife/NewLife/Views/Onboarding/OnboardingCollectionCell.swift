//
//  OnboardingCollectionCell.swift
//  Tawazon
//
//  Created by Shadi on 12/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class OnboardingCollectionCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var data: OnboardingCollectionCellData? {
        didSet {
            populateData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    private func initialize() {
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.kohinoorBold(ofSize: 16)
        
        subTitleLabel.textColor = UIColor.black.withAlphaComponent(0.68)
        subTitleLabel.font = UIFont.kohinoorRegular(ofSize: 15)
        subTitleLabel.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 1.3)
        
        iconImageView.contentMode = .scaleAspectFit
    }
    
    private func populateData() {
        guard let data = data else {
            return
        }
        iconImageView.image = UIImage(named: data.iconName)
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
    }
}
