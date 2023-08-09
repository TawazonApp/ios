//
//  MoreLibraryCollectionCell.swift
//  Tawazon
//
//  Created by mac on 17/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class MoreLibraryCollectionCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var data: MoreLibraryCellVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initialize() {
        self.layer.cornerRadius = 24.0
        
        cellView.backgroundColor = .clear
        cellView.layer.cornerRadius = 24.0
        
        backgroundColor = .black.withAlphaComponent(0.6)
        
        contentView.roundCorners(corners: .allCorners, radius: 24)
        contentView.layer.cornerRadius = 24.0
        contentView.backgroundColor = .clear
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        imageView.backgroundColor = .clear
        
        titleLabel.font = UIFont.munaBoldFont(ofSize: 20)
        titleLabel.textColor = UIColor.white
        titleLabel.backgroundColor = .clear
        
    }
    
    private func fillData() {
        titleLabel.text = data.title
        imageView.image = (data.imageName != nil) ? UIImage(named: data.imageName!) : nil
        contentView.frame = frame
        layoutIfNeeded()
        layoutSubviews()
    }
}
