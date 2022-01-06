//
//  PremiumPurchaseCollectionCell.swift
//  NewLife
//
//  Created by Shadi on 19/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumPurchaseCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var trialPeriodLabel: UILabel!
    
    @IBOutlet weak var checkButton: AnimatedCheckButton!
    
    var cellData: PremiumPurchaseCellVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        priceLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        priceLabel.textColor = UIColor.iris
        discountPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        discountPriceLabel.textColor = UIColor.slateGrey
        
        periodLabel.font = UIFont.kohinoorRegular(ofSize: 16)
        periodLabel.textColor = UIColor.iris
       
        trialPeriodLabel.font = UIFont.kohinoorRegular(ofSize: 12)
        trialPeriodLabel.textColor = UIColor.dark.withAlphaComponent(0.72)
        
        checkButton.color = UIColor.lightBlueGrey.cgColor
        checkButton.checkColor = UIColor.white.cgColor
        checkButton.checkBackgroundColor = UIColor.darkSlateBlue
        checkButton.checked = false
        checkButton.isUserInteractionEnabled = false
    }
    
    private func fillData() {
        let subscription = UserInfoManager.shared.subscription?.types.items.first(where: { $0.id == cellData.id })
        priceLabel.text = cellData.discountPrice
        if cellData.price != nil {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cellData.price ?? "")
            attributeString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            discountPriceLabel.attributedText = attributeString
            discountPriceLabel.isHidden = false
        } else {
            discountPriceLabel.isHidden = true
        }
        var tiralPeriod = subscription?.title
        if let trialDescription = cellData.trialDescription {
            tiralPeriod = tiralPeriod ?? "\("tryPruchaseForFreeTrial".localized) \(trialDescription)"
        }
        trialPeriodLabel.text = tiralPeriod
        periodLabel.text = cellData.getPeriodTitle()
    }
    
    func setSelectedStyle(selected: Bool) {
        cellData.isSelected = selected
        checkButton.checked = selected
    }
}
