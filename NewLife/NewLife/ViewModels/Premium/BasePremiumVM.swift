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
    
    static let shared: BasePremiumVM = BasePremiumVM()
    var premiumDetails: BasePremiumModel?{
        didSet{
        }
    }
    
    var products: [SKProduct] = [] {
        didSet {
            plansArray = purchaseItems()
        }
    }
    
    var plansArray: [PremiumPurchaseCellVM] = []
    
    enum PurchaseProccessTypes {
        case success
        case cancel
        case fail
    }
    
    func getPremiumPageDetails(premiumId: Int, service: MembershipService, completion: @escaping (CustomError?)-> Void){
        service.getPremiumDetails(viewId: premiumId, completion: { (data, error) in
            self.premiumDetails = data
            self.fetchPremiumPurchaseProducts(completion: {(error) in
                print("error: \(error)")
                completion(error)
            })
            
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
            let orgionalPrice = Float(truncating: product.price)
            var priceDecimal = NSDecimalNumber(value: orgionalPrice)
            orgionalPriceString = getPriceString(price: priceDecimal, locale: product.priceLocale)

            if product.productIdentifier == PremiumPurchase.yearly.rawValue {
                priceDecimal = NSDecimalNumber(value: orgionalPrice / 12)
            }else if product.productIdentifier == PremiumPurchase.threeMonth.rawValue{
                priceDecimal = NSDecimalNumber(value: orgionalPrice / 3)
            }
            let monthlyPriceString = getPriceString(price: priceDecimal, locale: product.priceLocale)
            
            if plan?.enabled ?? false{
                let planPriority = Int(plan?.priority ?? "") ?? 0
                let purchase = PremiumPurchaseCellVM(id: product.productIdentifier,title: plan?.title ?? "", subtitle: plan?.subtitle, color: plan?.color ?? "", price: orgionalPriceString ?? "", savingAmount: getPlanSavingAmount(plan: plan!), monthlyPrice: monthlyPriceString, discountPrice: discountPriceString, trialDescription: trialDescription, priority: planPriority)
                purchaseItems.append(purchase)
            }
            
        }
        purchaseItems.sort(by: { $0.order < $1.order })
        if purchaseItems.count == 1 {
            purchaseItems.first?.isSelected = true
        }
        return purchaseItems
    }
    private func getPlanSavingAmount(plan: Plan) -> Int{
        if let monthlyPlanPrice = products.filter({$0.productIdentifier == PremiumPurchase.monthly.rawValue}).first?.price{
            if let planProduct = self.products.filter({return $0.productIdentifier == plan.id}).first{
                let planPrice = Double(truncating: planProduct.price)
                if #available(iOS 11.2, *) {
                    var savingAmount = 0.0
                    savingAmount = 1 - (planPrice / (monthlyPlanPrice as! Double * Double(planProduct.subscriptionPeriod?.numberOfUnits ?? 0)) )
                    if planProduct.subscriptionPeriod?.unit == SKProduct.PeriodUnit.year{
                        savingAmount = 1 - (planPrice / (monthlyPlanPrice as! Double * Double(12 * (planProduct.subscriptionPeriod?.numberOfUnits ?? 0) )) )
                    }
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
    
    func purchase(purchaseId: PremiumPurchase, product: SKProduct?, completion: @escaping (PurchaseProccessTypes, CustomError?) -> Void) {
        SwiftyStoreKit.purchaseProduct(purchaseId.rawValue, atomically: false) { [weak self] result in
            
            if case .success(let purchase) = result {
//                self?.sendStartSubscriptionEvent(purchase: purchase)
               // if purchase.needsFinishTransaction {
                    let price = product?.price.doubleValue != nil ? "\(product!.price.doubleValue)" : ""
                    let currancy = product?.priceLocale.currencyCode ?? ""
                    self?.uploadPurchaseReceipt(price: price, currancy: currancy) {
                        completion(PurchaseProccessTypes.success, nil)
                    }
//                } else {
//                    completion(PurchaseProccessTypes.success, nil)
//                }
            } else if case .error(let error) = result {
                
                if let errorMessage = self?.purchaseErrorMessage(error: error) {
                    let errorResult = CustomError(message: errorMessage, statusCode: nil)
                    completion(PurchaseProccessTypes.fail, errorResult)
                } else {
//                    self?.sendCancelSubscriptionEvent(purchaseId: purchaseId)
                    completion(PurchaseProccessTypes.cancel, nil)
                }
            }
        }
    }
    
    func restorePurchase(completion: @escaping () -> Void) {
        if SwiftyStoreKit.localReceiptData != nil {
            uploadPurchaseReceipt(price: "", currancy: "", completion: completion)
            return
        }
        
        SwiftyStoreKit.restorePurchases { [weak self] (results) in
            guard SwiftyStoreKit.localReceiptData != nil else {
                completion()
                return
            }
            self?.uploadPurchaseReceipt(price: "", currancy: "",completion: completion)
        }
    }
    
    func redeemPromoCode(){
        let paymentQueue = SKPaymentQueue.default()
            if #available(iOS 14.0, *) {
                paymentQueue.presentCodeRedemptionSheet()
            }
    }
    
    func uploadPurchaseReceipt(price: String, currancy: String, completion: @escaping () -> Void) {
         let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
       appDelegate.uploadPurchaseReceipt(price: price, currancy: currancy) { (error) in
             if error == nil {
                 for transaction in appDelegate.paymentTransactions {
                     appDelegate.finishTransaction(paymentTransaction: transaction)
                 }
                 appDelegate.paymentTransactions.removeAll()
             }
             completion()
         }
     }
    
    func purchaseErrorMessage(error: SKError) -> String? {
            switch error.code {
            case .unknown:
                return error.localizedDescription
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return  "purchaseClientInvalid".localized
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return "purchasePaymentInvalid".localized
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return "purchasePaymentNotAllowed".localized
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return "purchaseStoreProductNotAvailable".localized
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                 return "purchaseCloudServicePermissionDenied".localized
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                 return "purchaseCloudServiceNetworkConnectionFailed".localized
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return "purchaseCloudServiceRevoked".localized
            default:
                return  (error as NSError).localizedDescription
            }
        
    }
}
