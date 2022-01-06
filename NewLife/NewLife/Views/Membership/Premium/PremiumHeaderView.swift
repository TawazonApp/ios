//
//  PremiumHeaderView.swift
//  NewLife
//
//  Created by Shadi on 19/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumHeaderView: UIView {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.clear
        
        logoImageView.image = #imageLiteral(resourceName: "Logo.pdf")
        titleLabel.font = UIFont.lbc(ofSize: 24)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "premiumTitle".localized
    }
}
