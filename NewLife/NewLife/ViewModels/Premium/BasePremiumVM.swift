//
//  BasePremiumVM.swift
//  Tawazon
//
//  Created by mac on 28/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit

class BasePremiumVM : NSObject{
    
    var premiumDetails: BasePremiumModel?{
        didSet{
            print("premiumDetails: \(premiumDetails?.premiumPage.title)")
            
        }
    }
    
    var products: [SKProduct] = [] {
        didSet {
            plansArray = purchaseItems()
            print("plansArray.counnt: \(plansArray.count)")
        }
    }
    
    var plansArray: [PremiumPurchaseCellVM] = []
    
    
    func getPremiumPageDetails(premiumId: Int, service: MembershipService, completion: @escaping (CustomError?)-> Void){
        service.getPremiumDetails(viewId: premiumId, completion: { (data, error) in
            self.premiumDetails = data
            self.fetchPremiumPurchaseProducts(completion: {(error) in
                print("error: \(error)")
            })
            completion(error)
        })
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
            let plan = premiumDetails?.plans.first(where: { $0.id == product.productIdentifier })
            let trialDescription = getTrialPeriod(product: product)
            let discountPrice = product.price
            let discountPriceString = getPriceString(price: discountPrice, locale: product.priceLocale)
            var orgionalPriceString: String?
            if let discount = plan?.discount, discount < 1 {
                let orgionalPrice = Float(truncating: product.price) / (1 - discount)
                let priceDecimal = NSDecimalNumber(value: orgionalPrice)
                orgionalPriceString = getPriceString(price: priceDecimal, locale: product.priceLocale)
            }
            print("product: \(product.priceLocale), \(product.price), \(orgionalPriceString), \(plan?.discount)")
            if plan?.enabled ?? false{
                let purchase = PremiumPurchaseCellVM(id: product.productIdentifier,title: plan?.title ?? "", color: plan?.color ?? "", price: orgionalPriceString ?? "", discountPrice: discountPriceString, trialDescription: trialDescription)
                purchaseItems.append(purchase)
            }
            
        }
        purchaseItems.sort(by: { $0.order < $1.order })
        if purchaseItems.count == 1 {
            purchaseItems.first?.isSelected = true
        }
        return purchaseItems
    }
    
    private func getTrialPeriod(product: SKProduct)-> String? {
        print("getTrialPeriod: \(product.localizedTitle)")
        var trialDescription: String? = nil
        if #available(iOS 11.2, *),
            let introductoryPrice = product.introductoryPrice, introductoryPrice.paymentMode == SKProductDiscount.PaymentMode.freeTrial {
            print("introductoryPrice: \(introductoryPrice.subscriptionPeriod)")
            let subscriptionPeriod = introductoryPrice.subscriptionPeriod
            trialDescription = subscriptionPeriod.unit.description(numberOfUnits: subscriptionPeriod.numberOfUnits)
        }
        print("trialDescription: \(trialDescription)")
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
