//
//  HomePremiumBanner2TableViewCell.swift
//  Tawazon
//
//  Created by mac on 20/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class HomePremiumGradientBannerTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerContainerView: BaseBannerView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tawazonTitleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
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
        
        gradientView.backgroundColor = .regalBlue
        gradientView.applyGradientColor(colors: [UIColor.lightCoral.cgColor, UIColor.ceSoir.cgColor, UIColor.regalBlue.cgColor, UIColor.regalBlue.withAlphaComponent(0.0).cgColor], startPoint: .topLeft, endPoint: .bottomRight)
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.backgroundColor = .clear
//        backgroundImage.image = UIImage(named: "HomeBanner2BG")
        
        tawazonTitleImage.contentMode = .scaleAspectFill
        tawazonTitleImage.backgroundColor = .clear
        tawazonTitleImage.image = UIImage(named: "HomeBanner2Logo")
        
//        titleLabel.text = "homePremiumBanner2Title".localized
        titleLabel.font = .munaBoldFont(ofSize: 32.0)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
//        subTitleLabel.text = "homePremiumBanner2SubTitle".localized
        subTitleLabel.font = .munaBoldFont(ofSize: 20.0)
        subTitleLabel.textColor = .white
        subTitleLabel.textAlignment = .center
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
