//
//  PremiumPlanCollectionViewCell.swift
//  Tawazon
//
//  Created by mac on 21/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumPlanCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var planTitlelabel: UILabel!
    @IBOutlet weak var planPricelabel: UILabel!
    @IBOutlet weak var planTriallabel: UILabel!
    
    var plan : PremiumPurchaseCellVM!{
        didSet{
            setData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .regalBlue
        
        planTitlelabel.layer.cornerRadius = 16.0
        planTitlelabel.roundCorners(corners: (Language.language == .arabic ? .bottomLeft : .bottomRight) , radius: 16)
        planTitlelabel.font = UIFont.munaBoldFont(ofSize: 18.0)
        planTitlelabel.textColor = .regalBlue
        
        planPricelabel.textColor = .white
        planPricelabel.font = UIFont.munaFont(ofSize: 16.0)
        
        planTriallabel.font = UIFont.munaFont(ofSize: 14.0)
        
    }
    private func setData(){
        contentView.layer.borderColor = UIColor(plan.color).cgColor
        contentView.layer.borderWidth = isSelected ? 1.5 : 0
        
        planTitlelabel.text = plan.title
        planPricelabel.text = getPriceString()
        planTriallabel.text = plan.trialDescription ?? ""
        planTitlelabel.backgroundColor = UIColor(plan.color)
        planTriallabel.textColor = UIColor(plan.color)
        
    }
    private func getPriceString() -> String{
        var priceString = "premium4PlanPriceString".localized
        return priceString.replacingOccurrences(of: "{price}", with: plan.price)
    }
    func setIsSelected(selected: Bool) {
        isSelected = selected
        plan.isSelected = selected
        setData()
    }
}
