//
//  PremiumFeatureCell.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumFeatureCell: UITableViewCell {
    
    @IBOutlet weak var iconView: LottieView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var cellData: PremiumFeatureCellVM! {
        didSet {
           fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    private func initialize() {
        backgroundColor = UIColor.clear
        iconView.backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.kacstPen(ofSize: 18)
        titleLabel.textColor = UIColor.white
    }
    
    private func fillData() {
        titleLabel.text = cellData.title
        iconView.iconName = cellData.iconAEName
    }
}
