//
//  PaywallPlanTableViewCell.swift
//  Tawazon
//
//  Created by mac on 11/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import Adapty

class PaywallPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var planView: GradientView!
    @IBOutlet weak var planHeaderLabel: UILabel!
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var pricesStack: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    var darkView: Bool?{
        didSet{
            initialize()
        }
    }
    
    
    var plan : PremiumPurchaseCellVM!{
        didSet{
            setData()
        }
    }
    
    var product : AdaptyPaywallProduct!{
        didSet{
            setAdaptyData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        darkView = RemoteConfigManager.shared.bool(forKey: .premuimPage6DarkTheme)
//        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initialize()
        setData()
    }
    
    private func initialize() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        contentView.backgroundColor = .clear
        
        planView.layer.cornerRadius = 24
        planView.clipsToBounds = true
        planView.backgroundColor = darkView! ? .clear : .ghostWhiteTwo
//        planView.gradientBorder(width: 1, colors: [.royalBlue, .mediumOrchid, .rockBlue], startPoint: .topLeft, endPoint: .bottomRight, andRoundCornersWithRadius: 24)
        
        planHeaderLabel.backgroundColor = darkView! ? .governorBay : .mediumPurple
        planHeaderLabel.layer.cornerRadius = 16.0
        planHeaderLabel.roundCorners(corners: (Language.language == .arabic ? .bottomLeft : .bottomRight) , radius: 16)
        planHeaderLabel.textColor = .white
        planHeaderLabel.font = .munaBoldFont(ofSize: 18)
        planHeaderLabel.textAlignment = .center
        
        planTitleLabel.font = .munaBoldFont(ofSize: 20)
        planTitleLabel.textColor = darkView! ? .white : .darkIndigoTwo
        
        priceLabel.font = .munaFont(ofSize: 24)
        priceLabel.textColor = darkView! ? .white : .darkIndigoTwo
        priceLabel.textAlignment = Language.language == .english ? .right : .left
        
        subPriceLabel.font = .munaFont(ofSize: 15)
        subPriceLabel.textColor = darkView! ? .white.withAlphaComponent(0.56) : .darkIndigoTwo.withAlphaComponent(0.56)
        subPriceLabel.textAlignment = Language.language == .english ? .left : .right
        
        discountLabel.font = .munaBoldFont(ofSize: 15)
        discountLabel.textColor = darkView! ? .lavenderBlue : .slateBlue
    }
    private func setData(){
        planHeaderLabel.layoutIfNeeded()
        planHeaderLabel.roundCorners(corners: (Language.language == .arabic ? .bottomLeft : .bottomRight) , radius: 16)
        planView.layoutIfNeeded()
        planView.layer.sublayers?.first(where: {$0.name == UIView.kLayerNameGradientBorder})?.removeFromSuperlayer()
        if darkView ?? false{
            if plan.isSelected{
                planView.gradientBorder(width: 2, colors: [.mayaBlue, .lavenderBlue, .white.withAlphaComponent(0.2)], startPoint: .topLeft, endPoint: .bottomRight, andRoundCornersWithRadius: 24)
            }else{
                planView.gradientBorder(width: 1, colors: [.mayaBlue.withAlphaComponent(0.5), .lavenderBlue.withAlphaComponent(0.5), .white.withAlphaComponent(0.2)], startPoint: .topLeft, endPoint: .bottomRight, andRoundCornersWithRadius: 24)
            }
        }
        else{
            if plan.isSelected{
                planView.gradientBorder(width: 2, colors: [.royalBlue, .mediumOrchid, .rockBlue], startPoint: .topLeft, endPoint: .bottomRight, andRoundCornersWithRadius: 24)
            }
            planView.layer.borderWidth = isSelected ? 0 : 1
            planView.layer.borderColor = UIColor.blueHaze.cgColor
        }
        
        
        if let subtitle = plan.subtitle{
            planHeaderLabel.text = subtitle
            planHeaderLabel.isHidden = false
        }else{
            planHeaderLabel.isHidden = true
        }

        planTitleLabel.text = plan.title
        priceLabel.text = plan.price
        subPriceLabel.text = plan.id == PremiumPurchase.monthly.rawValue ? "" : "(\(plan.monthlyPrice ?? "")\("paywallMonthlyString".localized))"
        if plan.savingAmount > 0{
            if Language.language == .english{
                discountLabel.text = "\("paywallSavingLabel".localized) \(plan.savingAmount ?? 0)%"
            }else{
                discountLabel.attributedText = discountLabelAttributeText(plan: plan)
            }
        }
    }
    
    private func setAdaptyData(){
        planHeaderLabel.layoutIfNeeded()
        planHeaderLabel.roundCorners(corners: (Language.language == .arabic ? .bottomLeft : .bottomRight) , radius: 16)
        planView.layoutIfNeeded()
        planView.layer.sublayers?.first(where: {$0.name == UIView.kLayerNameGradientBorder})?.removeFromSuperlayer()
        if darkView ?? false{
            if plan.isSelected{
                planView.gradientBorder(width: 2, colors: [.mayaBlue, .lavenderBlue, .white.withAlphaComponent(0.2)], startPoint: .topLeft, endPoint: .bottomRight, andRoundCornersWithRadius: 24)
            }else{
                planView.gradientBorder(width: 1, colors: [.mayaBlue.withAlphaComponent(0.5), .lavenderBlue.withAlphaComponent(0.5), .white.withAlphaComponent(0.2)], startPoint: .topLeft, endPoint: .bottomRight, andRoundCornersWithRadius: 24)
            }
        }
        else{
            if plan.isSelected{
                planView.gradientBorder(width: 2, colors: [.royalBlue, .mediumOrchid, .rockBlue], startPoint: .topLeft, endPoint: .bottomRight, andRoundCornersWithRadius: 24)
            }
            planView.layer.borderWidth = isSelected ? 0 : 1
            planView.layer.borderColor = UIColor.blueHaze.cgColor
        }
        
        
        if let subtitle = plan.subtitle{
            planHeaderLabel.text = subtitle
            planHeaderLabel.isHidden = false
        }else{
            planHeaderLabel.isHidden = true
        }

        planTitleLabel.text = plan.title
        priceLabel.text = plan.price
        subPriceLabel.text = plan.id == PremiumPurchase.monthly.rawValue ? "" : "(\(plan.monthlyPrice ?? "")\("paywallMonthlyString".localized))"
        if plan.savingAmount > 0{
            if Language.language == .english{
                discountLabel.text = "\("paywallSavingLabel".localized) \(plan.savingAmount ?? 0)%"
            }else{
                discountLabel.attributedText = discountLabelAttributeText(plan: plan)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setSelectedStyle(_ selected: Bool) {

    }
    
    private func discountLabelAttributeText(plan: PremiumPurchaseCellVM) -> NSMutableAttributedString {
        
        let discountPart1 = "paywallSavingLabel".localized
        let savingAmountPart2 = "\(plan.savingAmount ?? 0)%"
        let allText = String(format: "%@ %@", discountPart1, savingAmountPart2)
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.munaFont(ofSize: 15),.kern: 0.0])
        
        if let part2Range = allText.range(of: savingAmountPart2) {
            attributedString.addAttributes([.font: UIFont.munaBoldFont(ofSize: 15, language: .english)], range: part2Range.nsRange(in: allText))
        }
        return attributedString
    }
    
    func setIsSelected(selected: Bool) {
        isSelected = selected
        plan.isSelected = selected
        setData()
    }
}
