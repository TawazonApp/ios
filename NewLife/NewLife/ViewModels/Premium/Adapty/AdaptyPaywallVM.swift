//
//  AdaptyPaywallVM.swift
//  Tawazon
//
//  Created by mac on 14/03/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation
import Adapty
import StoreKit

class AdaptyPaywallVM: NSObject{
    var paywall: AdaptyPaywall?
    var products: [(isSelected: Bool, product: AdaptyPaywallProduct)]?{
        didSet{
            plansArray = purchaseItems()
        }
    }
    var paywallDetails: BaseAdaptyPaywallModel?{
        didSet{
//            plansArray = purchaseItems()
        }
    }
    
    var plansArray: [PremiumPurchaseCellVM] = []
    
    func fetchPaywallDetails(id: String, completion: @escaping (AdaptyError?) -> Void) {
        Adapty.getPaywall(id, locale: Language.language.rawValue) { result in
            switch result {
            case let .success(paywall):
                self.paywall = paywall
                self.paywallDetails = BaseAdaptyPaywallModel.init(paywall.remoteConfigString ?? "")
                Adapty.getPaywallProducts(paywall: paywall) { result in
                    switch result {
                    case let .success(products):
                        self.products = products.map{
                            return (isSelected: false, product: $0)
                        }
                        completion(nil)
                        break
                    case let .failure(error):
                        completion(error)
                        break
                    }
                }
                break
            case let .failure(error):
                completion(error)
                break
            }
        }
    }
    
    private func purchaseItems() -> [PremiumPurchaseCellVM] {
        var purchaseItems = [PremiumPurchaseCellVM]()
        for productData in products! {
            let plan = paywallDetails?.premiumPage.plans.first(where: { $0.id == productData.product.vendorProductId})
            let trialDescription = getTrialPeriod(product: productData.product.skProduct)
            let discountPrice = NSDecimalNumber(value: Float(truncating: productData.product.price as NSNumber))
            let discountPriceString = getPriceString(price: discountPrice, locale: productData.product.skProduct.priceLocale)
            var orgionalPriceString: String?
            let orgionalPrice = Float(truncating: productData.product.price as NSNumber)
            var priceDecimal = NSDecimalNumber(value: orgionalPrice)
            
            orgionalPriceString = getPriceString(price: priceDecimal, locale: productData.product.skProduct.priceLocale)
            
            if productData.product.vendorProductId == PremiumPurchase.yearly.rawValue {
                priceDecimal = NSDecimalNumber(value: orgionalPrice / 12)
            }else if productData.product.vendorProductId == PremiumPurchase.threeMonth.rawValue{
                priceDecimal = NSDecimalNumber(value: orgionalPrice / 3)
            }
            let monthlyPriceString = getPriceString(price: priceDecimal, locale: productData.product.skProduct.priceLocale)
            if plan?.enabled ?? false{
                let planPriority = Int(plan?.priority ?? "") ?? 0
                let purchase = PremiumPurchaseCellVM(id: productData.product.vendorProductId,title: plan?.title ?? "", subtitle: plan?.subtitle, color: plan?.color ?? "", price: orgionalPriceString ?? "", savingAmount: getPlanSavingAmount(plan: plan!), monthlyPrice: monthlyPriceString, discountPrice: discountPriceString, trialDescription: trialDescription, priority: planPriority)
                purchaseItems.append(purchase)
            }
        }
        purchaseItems.sort(by: { $0.order < $1.order })
        if purchaseItems.count == 1 {
            purchaseItems.first?.isSelected = true
        }
        return purchaseItems
    }
    
    private func getPlanSavingAmount(plan: AdaptyPlan) -> Int{
        if let monthlyPlanPrice = products?.filter({$0.product.vendorProductId == PremiumPurchase.monthly.rawValue}).first?.product.price{
            if let planProduct = self.products?.filter({return $0.product.vendorProductId == plan.id}).first?.product{
                let planPrice = Double(truncating: planProduct.price as NSNumber)
                
                if #available(iOS 11.2, *) {
                    var savingAmount = 0.0
                    savingAmount = 1 - (planPrice / (Double(truncating: monthlyPlanPrice as NSNumber) * Double(planProduct.subscriptionPeriod?.numberOfUnits ?? 0)) )
                    if planProduct.subscriptionPeriod?.unit == .year{
                        savingAmount = 1 - (planPrice / ((Double(truncating: monthlyPlanPrice as NSNumber) * Double(12 * (planProduct.subscriptionPeriod?.numberOfUnits ?? 0) )) ))
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
    
    func makePurchase(product: AdaptyPaywallProduct, completion: @escaping (AdaptyProfile?, AdaptyError?, String?) -> Void) {
        Adapty.makePurchase(product: product) { result in
            switch result {
            case let .success(profile):
                TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenSuccessProcess, payload: ["planId" : product.vendorProductId, "planName" : product.localizedTitle, "paywallName" : product.paywallName])
                UserInfoManager.shared.verifyAdaptyUser(service: MembershipServiceFactory.service()){
                }
                completion(profile, nil, nil)
            case let .failure(error):
                if error.adaptyErrorCode == .paymentCancelled{
                    TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenCancelProcess, payload: ["planId" : product.vendorProductId, "planName" : product.localizedTitle, "paywallName" : product.paywallName, "errorMessage" : "User cancelled the request"])
                }else{
                    TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenFailProcess, payload: ["planId" : product.vendorProductId, "planName" : product.localizedTitle, "paywallName" : product.paywallName, "errorMessage" : self.errorHandling(error: error)])
                }
                
                completion(nil, error, self.errorHandling(error: error))
            }
        }
    }
    
    func restorePurchases(completion: @escaping (AdaptyProfile?, AdaptyError?, String?) -> Void) {
        Adapty.restorePurchases { result in
            switch result {
                case let .success(profile):
                UserInfoManager.shared.verifyAdaptyUser(service: MembershipServiceFactory.service()){
                    TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenSuccessRestoreProcess, payload: ["planId" : profile.accessLevels["premium"]?.vendorProductId ?? ""])
                }
                completion(profile, nil, nil)
                case let .failure(error):
                TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenFailRestoreProcess, payload: ["errorMessage" : error.adaptyErrorCode])
                completion(nil, error, self.errorHandling(error: error))
            }
        }
    }
    
    func redeemPromoCode(){
        Adapty.presentCodeRedemptionSheet()
    }
    
    func errorHandling(error: AdaptyError) -> String? {
        var errorMessage: String?
        switch error.adaptyErrorCode{
        case .paymentCancelled:
            errorMessage = nil
        case .paymentNotAllowed:
            errorMessage = "paymentNotAllowed".localized
        case .clientInvalid:
            errorMessage = "clientInvalid".localized
        case .unknown:
            errorMessage = "unknown".localized
        case .paymentInvalid:
            errorMessage = "paymentInvalid".localized
        case .storeProductNotAvailable:
            errorMessage = "storeProductNotAvailable".localized
        case .cloudServicePermissionDenied:
            errorMessage = "cloudServicePermissionDenied".localized
        case .cloudServiceNetworkConnectionFailed:
            errorMessage = "cloudServiceNetworkConnectionFailed".localized
        case .cloudServiceRevoked:
            errorMessage = "cloudServiceRevoked".localized
        case .privacyAcknowledgementRequired:
            errorMessage = "privacyAcknowledgementRequired".localized
        case .unauthorizedRequestData:
            errorMessage = "unauthorizedRequestData".localized
        case .invalidOfferIdentifier:
            errorMessage = "invalidOfferIdentifier".localized
        case .invalidSignature:
            errorMessage = "invalidSignature".localized
        case .missingOfferParams:
            errorMessage = "missingOfferParams".localized
        case .invalidOfferPrice:
            errorMessage = "invalidOfferPrice".localized
        case .noProductIDsFound:
            errorMessage = "noProductIDsFound".localized
        case .productRequestFailed:
            errorMessage = "productRequestFailed".localized
        
        
        case .cantMakePayments:
            errorMessage = "In-App Purchases are not allowed on this device."
        case .noPurchasesToRestore:
            errorMessage = "No Purchases To Restore"
        case .cantReadReceipt:
            errorMessage = "cantReadReceipt"
        case .productPurchaseFailed:
            errorMessage = "productPurchaseFailed"
        case .refreshReceiptFailed:
            errorMessage = "refreshReceiptFailed"
        case .receiveRestoredTransactionsFailed:
            errorMessage = "receiveRestoredTransactionsFailed"
        case .notActivated:
            errorMessage = "Adapty SDK is not activated."
        case .badRequest:
            errorMessage = "badRequest"
        case .serverError:
            errorMessage = "serverError"
        case .networkFailed:
            errorMessage = "networkFailed"
        case .decodingFailed:
            errorMessage = "decodingFailed"
        case .encodingFailed:
            errorMessage = "encodingFailed"
        case .analyticsDisabled:
            errorMessage = "analyticsDisabled"
        case .wrongParam:
            errorMessage = "Wrong parameter was passed."
        case .activateOnceError:
            errorMessage = "It is not possible to call .activate method more than once."
        case .profileWasChanged:
            errorMessage = "The user profile was changed during the operation."
        case .unsupportedData:
            errorMessage = "unsupportedData"
        case .persistingDataError:
            errorMessage = "persistingDataError"
        case .operationInterrupted:
            errorMessage = "operationInterrupted"
        }
        return errorMessage
    }
}
