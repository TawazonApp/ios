//
//  HomePremiumBannerTableViewCell.swift
//  Tawazon
//
//  Created by mac on 06/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit




class HomePremiumBannerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bannerContainerView: BaseBannerView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titlePart1Label: UILabel!
    @IBOutlet weak var titlePart2Label: UILabel!
    @IBOutlet weak var purchaseButton: GradientButton!
    
    var data: HomeSectionVM? {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        bannerContainerView.layer.cornerRadius = 32.0
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.backgroundColor = .clear
//        backgroundImage.image = UIImage(named: "HomeBanner1BG")
        
        
        gradientView.backgroundColor = .clear
        gradientView.applyGradientColor(colors: [UIColor.licorice.cgColor, UIColor.eastBay.withAlphaComponent(0.74).cgColor, UIColor.darkIndigo.withAlphaComponent(0.0).cgColor], startPoint: .bottom, endPoint: .top)
        
//        titlePart1Label.text = "homePremiumBanner1TitlePart1".localized
        titlePart1Label.font = .munaFont(ofSize: 18.0)
        titlePart1Label.textColor = .white
        titlePart1Label.textAlignment = .center
        titlePart1Label.adjustsFontSizeToFitWidth = true
        titlePart1Label.minimumScaleFactor = 0.5
        
//        titlePart2Label.text = "homePremiumBanner1TitlePart2".localized
        titlePart2Label.font = .munaBoldFont(ofSize: 24.0)
        titlePart2Label.textColor = .white
        titlePart2Label.textAlignment = .center
        titlePart2Label.adjustsFontSizeToFitWidth = true
        titlePart2Label.minimumScaleFactor = 0.5
        
        purchaseButton.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .left, endPoint: .right)
//        purchaseButton.setTitle("homePremiumBanner1PurchaseButtonTitle".localized, for: .normal)
        purchaseButton.layer.cornerRadius = 20
        purchaseButton.tintColor = .white
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
        
    }

    private func reloadData() {
        titlePart1Label.text = data?.title
        titlePart2Label.text = data?.subTitle
        purchaseButton.setTitle(data?.buttonLabel, for: .normal)
        
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
