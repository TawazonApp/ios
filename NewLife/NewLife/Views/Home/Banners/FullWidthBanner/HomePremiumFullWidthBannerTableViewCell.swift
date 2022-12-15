//
//  HomePremiumBanner4TableViewCell.swift
//  Tawazon
//
//  Created by mac on 20/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class HomePremiumFullWidthBannerTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerContainerView: BaseBannerView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var stackImages: UIStackView!
    @IBOutlet var backgroundStackImages: [UIImageView]!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tawazonTitleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var moreButton: GradientButton!
    
    
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
        
        bannerContainerView.layer.cornerRadius = 0.0
        
        gradientView.backgroundColor = .clear
        gradientView.applyGradientColor(colors: [UIColor.blueZodiac.cgColor, UIColor.licorice.withAlphaComponent(0.74).cgColor, UIColor.eastBay.withAlphaComponent(0.0).cgColor], startPoint: .bottom, endPoint: .top)
        
        for (index, imageView) in backgroundStackImages.enumerated(){
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .clear
        }
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.backgroundColor = .clear
        
        tawazonTitleImage.contentMode = .scaleToFill
        tawazonTitleImage.backgroundColor = .clear
        tawazonTitleImage.image = UIImage(named: "HomeBanner2Logo")
        
        titleLabel.font = .munaBoldFont(ofSize: 28.0)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textColor = .white
        
        
        subTitleLabel.font = .munaBoldFont(ofSize: 24.0)
        subTitleLabel.textColor = .white
        subTitleLabel.adjustsFontSizeToFitWidth = true
        subTitleLabel.minimumScaleFactor = 0.5


        purchaseButton.backgroundColor = .white
        purchaseButton.layer.cornerRadius = 6
        purchaseButton.tintColor = .licorice
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
        
        moreButton.backgroundColor = .licorice.withAlphaComponent(0.36)
        moreButton.layer.cornerRadius = 6
        moreButton.layer.borderWidth = 1
        moreButton.layer.borderColor = UIColor.white.cgColor
        moreButton.tintColor = .white
        moreButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
    }
    
    private func reloadData() {
        titleLabel.text = data?.title
        subTitleLabel.text = data?.subTitle
        purchaseButton.setTitle(data?.buttonLabel, for: .normal)
        moreButton.setTitle(data?.moreLabel, for: .normal)
        
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
