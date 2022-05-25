//
//  HomePremiumBanner3TableViewCell.swift
//  Tawazon
//
//  Created by mac on 20/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class HomePremiumBanner3TableViewCell: UITableViewCell {

    @IBOutlet weak var bannerContainerView: BaseBannerView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        bannerContainerView.layer.cornerRadius = 32.0
        
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.layer.cornerRadius = 32.0
        backgroundImage.layer.masksToBounds = true
        backgroundImage.backgroundColor = .clear
        backgroundImage.image = UIImage(named: "HomeBanner3BG")
        
        headerImage.contentMode = .scaleToFill
        headerImage.backgroundColor = .clear
        headerImage.image = UIImage(named: "HomeBanner3Header")
        
        titleLabel.text = "homePremiumBanner3Title".localized
        titleLabel.font = .munaFont(ofSize: 20.0)
        titleLabel.textColor = .cyprus
        
        subTitleLabel.text = "homePremiumBanner3SubTitle".localized
        subTitleLabel.font = .munaBoldFont(ofSize: 28.0)
        subTitleLabel.textColor = .cyprus
        subTitleLabel.numberOfLines = 0
        subTitleLabel.lineBreakMode = .byWordWrapping
        
        purchaseButton.backgroundColor = .white
        purchaseButton.setTitle("homePremiumBanner3PurchaseButtonTitle".localized, for: .normal)
        purchaseButton.layer.cornerRadius = 24
        purchaseButton.tintColor = .cyprus
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
    }
}
