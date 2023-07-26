//
//  MoreCell.swift
//  NewLife
//
//  Created by Shadi on 28/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var data: MoreCellVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        self.selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = .clear
        
        titleLabel.font = UIFont.munaBoldFont(ofSize: 20)
        titleLabel.textColor = UIColor.white
        
        subTitleLabel.font = UIFont.munaFont(ofSize: 14)
        subTitleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        
    }
    
     func fillData() {
        
        iconImageView.image = (data.imageName != nil) ? UIImage(named: data.imageName!) : nil
        
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
    }
}
