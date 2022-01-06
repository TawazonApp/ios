//
//  PremiumPurchaseSummaryVM.swift
//  NewLife
//
//  Created by Shadi on 03/04/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumPurchaseSummaryVM: NSObject {

    var id: String!
    var title: String!
    var subTitle: String!
    var descriptionString: String!
    var expireString: String?
    var image: UIImage?
    var isCoupon: Bool = false
    
    init(id: String, price: String, expireDate: Date?, isTrial: Bool?) {
        super.init()
        self.id = id
        self.title = getTitle()
        self.subTitle = (isTrial == true) ? "premiumSummaryTrialPeriod".localized: ""
        self.descriptionString = getDesrciption(price: price)
        self.expireString = (expireDate != nil) ? getFullExpireDateString(expireDate: expireDate!) : nil
        let iconName = getIconName()
        self.image = (iconName != nil) ? UIImage(named: iconName!) : nil
        self.isCoupon = id == PremiumPurchase.coupon.rawValue
    }
    
    private func getTitle()-> String {
        var title = ""
        if id == PremiumPurchase.monthly.rawValue {
            title = "monthlyPurchaseTitle".localized
        } else if id == PremiumPurchase.yearly.rawValue {
            title = "yearlyPurchaseTitle".localized
        } else if id == PremiumPurchase.lifetime.rawValue {
            title = "lifeTimePurchaseTitle".localized
        }  else if id == PremiumPurchase.halfYearly.rawValue {
            title = "halfYearlyPurchaseTitle".localized
        } else if id == PremiumPurchase.threeMonth.rawValue {
            title = "threeMonthsPurchaseTitle".localized
        } else if id == PremiumPurchase.coupon.rawValue {
            title = "couponPurchaseTitle".localized
        }
        return title
    }
    
    private func getSubTitle(price: String)-> String {
        var subTitle = ""
        if id == PremiumPurchase.monthly.rawValue {
            subTitle = "monthlyPurchaseSubTitle".localized
        } else if id == PremiumPurchase.yearly.rawValue {
            subTitle = "yearlyPurchaseSubTitle".localized
        } else if id == PremiumPurchase.lifetime.rawValue {
            subTitle = "lifeTimePurchaseSubTitle".localized
        } 
        subTitle = subTitle.replacingOccurrences(of: "{price}", with: price)
        return subTitle
    }
    
    private func getDesrciption(price: String) -> String {
        
        var description = ""
        if id == PremiumPurchase.monthly.rawValue {
            description = "monthlyPurchaseDescription".localized
        } else if id == PremiumPurchase.yearly.rawValue {
            description = "yearlyPurchaseDescription".localized
        } else if id == PremiumPurchase.lifetime.rawValue {
            description = "lifeTimePurchaseDescription".localized
        }
        
        description = description.localized.replacingOccurrences(of: "{price}", with: price)
        return description
    }
    
    private func getIconName() -> String? {
        
        var iconName: String?
        if id == PremiumPurchase.monthly.rawValue {
            iconName = "PurchaseMonthly"
        } else if id == PremiumPurchase.yearly.rawValue {
            iconName = "PurchaseYearly"
        } else if id == PremiumPurchase.lifetime.rawValue {
            iconName = "PurchaseLifetime"
        }  else if id == PremiumPurchase.coupon.rawValue {
            iconName = "PurchaseLifetime"
        }
        return iconName
    }
    
    private func getFullExpireDateString(expireDate: Date) -> String {
        return "premiumPurchaseSummaryExpireDate".localized.appending(" \(getExpireDateString(expireDate: expireDate))")
    }
    
    private func getExpireDateString(expireDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: expireDate)
    }
    
}
