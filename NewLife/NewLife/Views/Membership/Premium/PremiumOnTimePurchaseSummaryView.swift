//
//  PremiumOnTimePurchaseResultView.swift
//  NewLife
//
//  Created by Shadi on 30/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumOnTimePurchaseSummaryView: UIView {
    
    @IBOutlet weak var heaerTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageview: UIImageView!
    @IBOutlet weak var separatorImageview: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    var data: PremiumPurchaseSummaryVM? {
        didSet{
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        
        heaerTitleLabel.font = UIFont.lbcBold(ofSize: 17)
        heaerTitleLabel.textColor = UIColor.white
        heaerTitleLabel.text = "premiumPurchaseSummaryHeaderTitle".localized
        
        titleLabel.textColor = UIColor.darkSlateBlue
        titleLabel.font = UIFont.kacstPen(ofSize: 22)
        
        subTitleLabel.textColor = UIColor.darkSlateBlue
        subTitleLabel.font = UIFont.kacstPen(ofSize: 14)
        
        separatorImageview.image = UIImage(named: "PremiumPurchaseIcon")
        
    }
    
    private func fillData() {
        titleLabel.text = data?.title
        subTitleLabel.text = data?.subTitle
        iconImageview.image = data?.image
    }

}
