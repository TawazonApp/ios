//
//  HomePremiumBanner5TableViewCell.swift
//  Tawazon
//
//  Created by mac on 20/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class HomePremiumBannerWithHeaderLogoTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerContainerView: BaseBannerView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tawazonTitleImage: GradientImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tawazonLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var data: HomeSectionVM? {
        didSet {
            reloadData()
        }
    }
    
    
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
//        backgroundImage.image = UIImage(named: "HomeBanner5BG")
        
        gradientView.backgroundColor = .clear
        gradientView.applyGradientColor(colors: [UIColor.black.cgColor, UIColor.black.withAlphaComponent(0.45).cgColor,  UIColor.black.withAlphaComponent(0.0).cgColor], startPoint: .bottom, endPoint: .top)



        tawazonTitleImage.contentMode = .center
        tawazonTitleImage.backgroundColor = .clear
        tawazonTitleImage.layer.cornerRadius = 8
        tawazonTitleImage.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .topLeft, endPoint: .bottomRight)
//        tawazonTitleImage.image = Language.language == .arabic ? UIImage(named: "HomeBanner5Logo") : UIImage(named: "HomeBanner5LogoEng")

        tawazonLabel.font = .munaBoldFont(ofSize: 28.0)
        tawazonLabel.textColor = .white
        tawazonLabel.textAlignment = .center
        tawazonLabel.text = "tawazon".localized
        tawazonLabel.adjustsFontSizeToFitWidth = true
        tawazonLabel.minimumScaleFactor = 0.35
        tawazonLabel.baselineAdjustment = .alignCenters
        
        premiumLabel.font = .munaBoldFont(ofSize: 28.0)
        premiumLabel.textColor = .deepLilac
        premiumLabel.backgroundColor = .white
        premiumLabel.layer.cornerRadius = 4
        premiumLabel.layer.masksToBounds = true
        premiumLabel.textAlignment = .center
        premiumLabel.text = "premium".localized
        premiumLabel.adjustsFontSizeToFitWidth = true
        premiumLabel.minimumScaleFactor = 0.35
        premiumLabel.baselineAdjustment = .alignCenters
        
//        titleLabel.text = "homePremiumBanner5Title".localized
        titleLabel.font = .munaBoldFont(ofSize: 28.0)
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5

//        subTitleLabel.text = "homePremiumBanner5SubTitle".localized
        subTitleLabel.font = .munaFont(ofSize: 18.0)
        subTitleLabel.textColor = .white
        subTitleLabel.numberOfLines = 0
        subTitleLabel.lineBreakMode = .byWordWrapping
        subTitleLabel.adjustsFontSizeToFitWidth = true
        subTitleLabel.minimumScaleFactor = 0.5
    }
    
    private func reloadData() {
        titleLabel.text = data?.title
        subTitleLabel.text = data?.subTitle
        
        loadBannerImage()
    }
    private func loadBannerImage(){
        backgroundImage.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor).isActive = true
        loadingIndicator.center = backgroundImage.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = data?.imageUrl?.url {
            backgroundImage.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
            
        }
    }
}
