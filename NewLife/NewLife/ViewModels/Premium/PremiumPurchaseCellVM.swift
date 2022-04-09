//
//  PremiumPurchaseCellVM.swift
//  NewLife
//
//  Created by Shadi on 19/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumPurchaseCellVM: NSObject {

    var id: String!
    var iconName: String?
    var title: String!
    var color: String!
    var price: String!
    var descriptionString: String!
    var isSelected: Bool!
    var order: Int!
    var discountPrice: String?
    var trialDescription: String?
    
    init(id: String!, title: String, color: String, price: String, discountPrice: String?, trialDescription: String?, isSelected: Bool? = false) {
        super.init()
        self.id = id
        self.title = title
        self.color = color
        self.price = price
        self.discountPrice = discountPrice
        self.trialDescription = trialDescription
        
        self.descriptionString = getDesrciption(price: price, trialDescription: trialDescription)
        self.iconName = getIconName()
        self.isSelected = isSelected
        order = getOrder()
    }
    
    private func getOrder() -> Int {
        var order: Int = Int.max
        if id == PremiumPurchase.monthly.rawValue {
            order = 4
        } else if id == PremiumPurchase.yearly.rawValue {
            order = 1
        } else if id == PremiumPurchase.halfYearly.rawValue {
            order = 2
        } else if id == PremiumPurchase.threeMonth.rawValue {
            order = 3
        } else if id == PremiumPurchase.lifetime.rawValue {
             order = 5
        }
        return order
    }
    
     func getPeriodTitle()-> String {
        var subTitle = ""
        if id == PremiumPurchase.monthly.rawValue {
            subTitle = "monthlyPurchaseSubTitle".localized
        } else if id == PremiumPurchase.yearly.rawValue {
            subTitle = "yearlyPurchaseSubTitle".localized
        } else if id == PremiumPurchase.halfYearly.rawValue {
            subTitle = "halfYearlyPurchaseSubTitle".localized
        } else if id == PremiumPurchase.threeMonth.rawValue {
            subTitle = "threeMonthsPurchaseSubTitle".localized
        } else if id == PremiumPurchase.lifetime.rawValue {
            subTitle = "lifeTimePurchaseSubTitle".localized
        }
        return subTitle
    }
    
    func getTitle() -> String {
        var title = ""
        if id == PremiumPurchase.monthly.rawValue {
            title = "monthlyPurchaseTitle".localized
        } else if id == PremiumPurchase.yearly.rawValue {
            title = "yearlyPurchaseTitle".localized
        } else if id == PremiumPurchase.halfYearly.rawValue {
            title = "halfYearlyPurchaseTitle".localized
        } else if id == PremiumPurchase.threeMonth.rawValue {
            title = "threeMonthsPurchaseTitle".localized
        } else if id == PremiumPurchase.lifetime.rawValue {
            title = "lifeTimePurchaseTitle".localized
        }
        return title
    }
    /*
     subTitle = subTitle.replacingOccurrences(of: "{price}", with: price)
     if trialDescription != nil {
         subTitle.append(" \("purchaseAfterTiralPeriodSubTitle".localized)")
     }
     */
    private func getDesrciption(price: String, trialDescription: String?) -> String {
        
        var description = ""
        if id == PremiumPurchase.monthly.rawValue {
            description = "monthlyPurchaseDescription".localized
        } else if id == PremiumPurchase.yearly.rawValue {
            description = "yearlyPurchaseDescription".localized
        } else if id == PremiumPurchase.halfYearly.rawValue {
            description = "halfYearlyPurchaseDescription".localized
        } else if id == PremiumPurchase.threeMonth.rawValue {
            description = "threeMonthsPurchaseDescription".localized
        } else if id == PremiumPurchase.lifetime.rawValue {
            description = "lifeTimePurchaseDescription".localized
        }
        
         description = description.localized.replacingOccurrences(of: "{price}", with: price)
        
        if trialDescription != nil {
            let tiralString = "purchaseAfterTiralPeriodDescription".localized.replacingOccurrences(of: "{trial_period}", with: trialDescription ?? "")
            description = "\(tiralString) \(description)"
        }
        return description
    }
    private func getIconName() -> String? {
        
        var iconName: String? = nil
        if id == PremiumPurchase.monthly.rawValue {
            iconName = "PurchaseMonthly"
        } else if id == PremiumPurchase.yearly.rawValue {
             iconName = "PurchaseYearly"
        } else if id == PremiumPurchase.halfYearly.rawValue {
             iconName = "PurchaseLifetime"
        }  else if id == PremiumPurchase.threeMonth.rawValue {
             iconName = "PurchaseMonthly"
        } else if id == PremiumPurchase.lifetime.rawValue {
             iconName = "PurchaseLifetime"
        }
        return iconName
    }
}
