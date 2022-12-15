//
//  PremiumPurchasesVM.swift
//  NewLife
//
//  Created by Shadi on 19/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class PremiumPurchaseVM: NSObject {

    let iconName: String = "PremiumPurchaseIcon"
    let title: String = "premiumPurchaseTitle".localized
    let defaultDescriptionString = "defaultPurchaseDescription".localized
    var privacyAttributeString: NSAttributedString?
    var termsAttributeString: NSAttributedString?
    
    var products: [SKProduct] = [] {
        didSet {
            tableArray = purchaseItems()
        }
    }
    
    var tableArray: [PremiumPurchaseCellVM] = []
    
    override init() {
        super.init()
        termsAttributeString = termsAndConditionsAttributeText()
        privacyAttributeString = privacyPolicyAttributeText()
    }
    
    private func termsAndConditionsAttributeText() -> NSMutableAttributedString {
        
        let privacyPolicyPart1 = "premiumPrivacyPolicyPart1".localized
        let termsAndConditionsPart2 = "premiumTermsAndConditionsPart2".localized
        let allText = String(format: "%@ %@", privacyPolicyPart1, termsAndConditionsPart2)
        
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.kacstPen(ofSize: 12), .foregroundColor: UIColor.darkSlateBlue.withAlphaComponent(0.64),.kern: 0.0])
        
        if let part2Range = allText.range(of: termsAndConditionsPart2) {
            attributedString.addAttributes([.foregroundColor: UIColor.darkSlateBlue, .underlineStyle: NSUnderlineStyle.single.rawValue], range:  part2Range.nsRange(in: allText))
        }
        return attributedString
    }
    
    private func privacyPolicyAttributeText() -> NSMutableAttributedString {
        
        let privacyPolicy = "premiumPrivacyPolicy".localized
        
        let attributedString = NSMutableAttributedString(string: privacyPolicy, attributes: [.font: UIFont.kacstPen(ofSize: 12), .foregroundColor: UIColor.darkSlateBlue,.kern: 0.0, .underlineStyle: NSUnderlineStyle.single.rawValue])
        
        return attributedString
    }

    func fetchPremiumPurchaseProducts(completion: @escaping (CustomError?) -> Void) {
        
        var productIds: Set<String> = []
        for identifier in PremiumPurchase.allProducts {
            productIds.insert(identifier.rawValue)
        }
        
        SwiftyStoreKit.retrieveProductsInfo(productIds) { [weak self] (result) in
            
            self?.products = result.retrievedProducts.map({$0})
            var fetchError: CustomError? = nil
            if let error =  result.error {
                let nsError = (error as NSError)
                let message: String? = nsError.localizedFailureReason ?? nsError.localizedDescription
                fetchError = CustomError(message: message, statusCode: nsError.code)
            }
            completion(fetchError)
        }
    }
    
    
    private func purchaseItems() -> [PremiumPurchaseCellVM] {
        var purchaseItems = [PremiumPurchaseCellVM]()
        for product in products {
            let subscription = UserInfoManager.shared.subscription?.types.items.first(where: { $0.id == product.productIdentifier })
            let trialDescription = getTrialPeriod(product: product)
            let discountPrice = product.price
            let discountPriceString = getPriceString(price: discountPrice, locale: product.priceLocale)
            var orgionalPriceString: String?
            if let discount = subscription?.discount, discount < 1 {
                let orgionalPrice = Float(truncating: product.price) / (1 - discount)
                let priceDecimal = NSDecimalNumber(value: orgionalPrice)
                orgionalPriceString = getPriceString(price: priceDecimal, locale: product.priceLocale)
            }
            
            let purchase = PremiumPurchaseCellVM(id: product.productIdentifier,title: product.localizedTitle, color: "", price: orgionalPriceString ?? "", savingAmount: 0, discountPrice: discountPriceString, trialDescription: trialDescription)
            purchaseItems.append(purchase)
        }
        purchaseItems.sort(by: { $0.order < $1.order })
        return purchaseItems
    }
    
    private func getPlanSavingAmount(plan: Plan) -> Int{
        if let monthlyPlanPrice = products.filter({$0.productIdentifier == PremiumPurchase.monthly.rawValue}).first?.price{
            if let planProduct = self.products.filter({return $0.productIdentifier == plan.id}).first{
                let planPrice = Double(truncating: planProduct.price)
                if #available(iOS 11.2, *) {
                    let savingAmount = 1 - (planPrice / (monthlyPlanPrice as! Double * Double(planProduct.subscriptionPeriod?.numberOfUnits ?? 0)) )
                    return Int(round(savingAmount * 100))
                }
            }
        }
        return 0
    }
    
    private func getTrialPeriod(product: SKProduct)-> String? {
        var trialDescription: String? = nil
        if #available(iOS 11.2, *),
            let introductoryPrice = product.introductoryPrice, introductoryPrice.paymentMode == SKProductDiscount.PaymentMode.freeTrial {
            let subscriptionPeriod = introductoryPrice.subscriptionPeriod
            trialDescription = subscriptionPeriod.unit.description(numberOfUnits: subscriptionPeriod.numberOfUnits)
        }
        return trialDescription
    }
    
    private func getDiscountPrice(product: SKProduct)-> NSDecimalNumber? {
        if #available(iOS 11.2, *),
           let introductoryPrice = product.introductoryPrice, introductoryPrice.paymentMode == SKProductDiscount.PaymentMode.payAsYouGo {
            return product.introductoryPrice?.price
        }
        return nil
    }
    
    func getPriceString(price: NSDecimalNumber, locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        return formatter.string(from: price) ?? ""
    }
}


