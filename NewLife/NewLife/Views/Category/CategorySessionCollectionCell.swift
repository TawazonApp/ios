//
//  CategorySessionCollectionCell.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AlamofireImage

class CategorySessionCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: GradientView!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var session: CategorySessionVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        lockImageView.contentMode = .center
        lockImageView.image = #imageLiteral(resourceName: "SessionLock.pdf")
        
        nameLabel.font = UIFont.lbcBold(ofSize: 16, language: .arabic)
        nameLabel.textColor = UIColor.white
        
        durationLabel.font = UIFont.lbc(ofSize: 14)
        durationLabel.textColor = UIColor.white
        overlayView.applyGradientColor(colors: [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.56).cgColor], startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
    }
    
    private func fillData() {
        
        imageView.image = nil
        if let imageUrl = session.imageUrl?.url {
            imageView.af.setImage(withURL: imageUrl)
        }
        
        nameLabel.text = session.name
        durationLabel.text = session.durationString
        
        lockImageView.isHidden = !session.isLock
    }
}
