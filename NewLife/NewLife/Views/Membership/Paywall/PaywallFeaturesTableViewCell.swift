//
//  PaywallFeaturesTableViewCell.swift
//  Tawazon
//
//  Created by mac on 11/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class PaywallFeaturesTableViewCell: UITableViewCell {

    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var premiumPlanImageView: UIImageView!
    @IBOutlet weak var freePlanImageView: UIImageView!
    
    var darkView: Bool?{
        didSet{
            initialize()
        }
    }
    
    var feature: FeatureItem? {
        didSet {
            setData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        darkView = RemoteConfigManager.shared.bool(forKey: .premuimPage6DarkTheme)
//        initialize()
    }

    private func initialize() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        featureLabel.font = .munaFont(ofSize: 16)
        featureLabel.textColor = darkView! ? .white : .darkIndigoTwo
        featureLabel.numberOfLines = 0
        featureLabel.lineBreakMode = .byWordWrapping
        
        premiumPlanImageView.backgroundColor = .clear
        premiumPlanImageView.contentMode = .scaleAspectFit
        
        freePlanImageView.backgroundColor = .clear
        freePlanImageView.contentMode = .scaleAspectFit
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    private func setSelectedStyle(_ selected: Bool) {

    }
    
    private func setData(){
        featureLabel.text = feature?.content
        let availableImage = UIImage(named: darkView! ? "PaywallFeatureAvailableDark" : "PaywallFeatureAvailable")
        let unavailableImage = UIImage(named: darkView! ? "PaywallFeatureUnavailableDark" : "PaywallFeatureUnavailable")
        premiumPlanImageView.image = feature?.planComp?.premium ?? false ? availableImage : unavailableImage
        freePlanImageView.image = feature?.planComp?.free ?? false ? availableImage: unavailableImage
    }
}
