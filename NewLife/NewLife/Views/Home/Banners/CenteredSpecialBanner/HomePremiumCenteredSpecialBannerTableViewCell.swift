//
//  HomePremiumBanner3TableViewCell.swift
//  Tawazon
//
//  Created by mac on 20/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class HomePremiumCenteredSpecialBannerTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerContainerView: BaseBannerView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
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
//        backgroundImage.image = UIImage(named: "HomeBanner3BG")
        
        headerImage.contentMode = .scaleToFill
        headerImage.backgroundColor = .clear
        headerImage.image = UIImage(named: "HomeBanner3Header")
        
//        titleLabel.text = "homePremiumBanner3Title".localized
        titleLabel.font = .munaFont(ofSize: 20.0)
        titleLabel.textColor = .cyprus
        
//        subTitleLabel.text = "homePremiumBanner3SubTitle".localized
        subTitleLabel.font = .munaBoldFont(ofSize: 28.0)
        subTitleLabel.textColor = .cyprus
        subTitleLabel.numberOfLines = 0
        subTitleLabel.lineBreakMode = .byWordWrapping
        
        purchaseButton.backgroundColor = .white
//        purchaseButton.setTitle("homePremiumBanner3PurchaseButtonTitle".localized, for: .normal)
        purchaseButton.layer.cornerRadius = 24
        purchaseButton.tintColor = .cyprus
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
    }
    
    private func reloadData() {
        titleLabel.text = data?.title
        subTitleLabel.text = data?.subTitle
        purchaseButton.setTitle(data?.buttonLabel, for: .normal)
        
        loadBannerImage()
    }
    private func loadBannerImage(){
        headerImage.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        headerImage.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: headerImage.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: headerImage.centerYAnchor).isActive = true
        loadingIndicator.center = headerImage.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = data?.imageUrl?.url {
            headerImage.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
            
        }
    }
}
