//
//  HomePremiumBanner4TableViewCell.swift
//  Tawazon
//
//  Created by mac on 20/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class HomePremiumBanner4TableViewCell: UITableViewCell {

    @IBOutlet weak var bannerContainerView: BaseBannerView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var stackImages: UIStackView!
    @IBOutlet var backgroundStackImages: [UIImageView]!
    @IBOutlet weak var tawazonTitleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var moreButton: GradientButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
    
    func initialize() {
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        bannerContainerView.layer.cornerRadius = 0.0
        
        gradientView.backgroundColor = .clear
        gradientView.applyGradientColor(colors: [UIColor.blueZodiac.cgColor, UIColor.licorice.withAlphaComponent(0.74).cgColor, UIColor.eastBay.withAlphaComponent(0.0).cgColor], startPoint: .bottom, endPoint: .top)
        
        for (index, imageView) in backgroundStackImages.enumerated(){
            imageView.contentMode = .scaleToFill
            imageView.backgroundColor = .clear
            imageView.image = UIImage(named: "HomeBanner4BG\(index)")
        }
        
        
        tawazonTitleImage.contentMode = .scaleToFill
        tawazonTitleImage.backgroundColor = .clear
        tawazonTitleImage.image = UIImage(named: "HomeBanner2Logo")
        
        titleLabel.text = "homePremiumBanner4Title".localized
        titleLabel.font = .munaBoldFont(ofSize: 28.0)
        titleLabel.textColor = .white
        
        
        subTitleLabel.text = "homePremiumBanner4SubTitle".localized
        subTitleLabel.font = .munaBoldFont(ofSize: 24.0)
        subTitleLabel.textColor = .white


        purchaseButton.backgroundColor = .white
        purchaseButton.setTitle("homePremiumBanner4PurchaseButtonTitle".localized, for: .normal)
        purchaseButton.layer.cornerRadius = 6
        purchaseButton.tintColor = .licorice
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
        
        moreButton.backgroundColor = .licorice.withAlphaComponent(0.36)
        moreButton.setTitle("homePremiumBanner4MoreButtonTitle".localized, for: .normal)
        moreButton.layer.cornerRadius = 6
        moreButton.layer.borderWidth = 1
        moreButton.layer.borderColor = UIColor.white.cgColor
        moreButton.tintColor = .white
        moreButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
    }
}
