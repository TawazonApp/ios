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
        backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.kacstPen(ofSize: 20)
        titleLabel.textColor = UIColor.white
        
        subTitleLabel.font = UIFont.kacstPen(ofSize: 12)
        subTitleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        
    }
    
     func fillData() {
        
        iconImageView.image = (data.imageName != nil) ? UIImage(named: data.imageName!) : nil
        
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
    }
}
