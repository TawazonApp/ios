//
//  ProfileCell.swift
//  NewLife
//
//  Created by Shadi on 11/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    var cellData: ProfileCellVM! {
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
        
        iconImageView.layer.masksToBounds = false
        
        titleLabel.font = UIFont.kacstPen(ofSize: 17)
        titleLabel.textColor = UIColor.white
        
        separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.10)
    }
    private func fillData() {
        titleLabel.text = cellData.title
        imageView?.image = UIImage(named: cellData.imageName)
    }
}
