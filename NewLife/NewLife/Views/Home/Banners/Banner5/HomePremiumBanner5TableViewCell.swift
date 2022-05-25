//
//  HomePremiumBanner5TableViewCell.swift
//  Tawazon
//
//  Created by mac on 20/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class HomePremiumBanner5TableViewCell: UITableViewCell {

    @IBOutlet weak var bannerContainerView: BaseBannerView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tawazonTitleImage: GradientImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        bannerContainerView.layer.cornerRadius = 32.0
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.layer.cornerRadius = 32.0
        backgroundImage.layer.masksToBounds = true
        backgroundImage.backgroundColor = .clear
        backgroundImage.image = UIImage(named: "HomeBanner5BG")
        
        gradientView.backgroundColor = .clear
        gradientView.applyGradientColor(colors: [UIColor.black.cgColor, UIColor.black.withAlphaComponent(0.45).cgColor,  UIColor.black.withAlphaComponent(0.0).cgColor], startPoint: .bottom, endPoint: .top)



        tawazonTitleImage.contentMode = .center
        tawazonTitleImage.backgroundColor = .clear
        tawazonTitleImage.layer.cornerRadius = 8
        tawazonTitleImage.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .topLeft, endPoint: .bottomRight)
        tawazonTitleImage.image = UIImage(named: "HomeBanner5Logo")

        titleLabel.text = "homePremiumBanner5Title".localized
        titleLabel.font = .munaBoldFont(ofSize: 28.0)
        titleLabel.textColor = .white

        subTitleLabel.text = "homePremiumBanner5SubTitle".localized
        subTitleLabel.font = .munaFont(ofSize: 18.0)
        subTitleLabel.textColor = .white
        subTitleLabel.numberOfLines = 0
        subTitleLabel.lineBreakMode = .byWordWrapping
    }
}
