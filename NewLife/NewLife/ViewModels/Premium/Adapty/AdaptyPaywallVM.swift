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
                let jsonEncoder = JSONEncoder()
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
            let discountPrice = productData.product.price
            let discountPriceString = getPriceString(price: NSDecimalNumber(nonretainedObject: discountPrice), locale: productData.product.skProduct.priceLocale)
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
    
    func makePurchase(product: AdaptyPaywallProduct, completion: @escaping (AdaptyProfile?, AdaptyError?) -> Void) {
        Adapty.makePurchase(product: product) { result in
            switch result {
            case let .success(profile):
                completion(profile, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
    func restorePurchases(completion: @escaping (AdaptyProfile?, AdaptyError?) -> Void) {
        Adapty.restorePurchases { [weak self] result in
            switch result {
                case let .success(profile):
                completion(profile, nil)
                case let .failure(error):
                completion(nil, error)
            }
        }
    }
    func errorHandling(error: AdaptyError) -> String {
        var errorMessage: String = ""
        switch error.adaptyErrorCode{
        case .paymentCancelled:
            print("User cancelled the request, etc.")
            errorMessage = "User cancelled the request, etc."
        case .paymentNotAllowed:
            print("This device is not allowed to make the payment.")
            errorMessage = "This device is not allowed to make the payment."
        case .clientInvalid:
            print("Client is not allowed to make a request, etc.")
            errorMessage = "Client is not allowed to make a request, etc."
        case .unknown:
            print("unknown")
            errorMessage = "unknown"
        case .paymentInvalid:
            print("Invalid purchase identifier, etc.")
            errorMessage = "Invalid purchase identifier, etc."
        case .storeProductNotAvailable:
            print("Product is not available in the current storefront.")
            errorMessage = "Product is not available in the current storefront."
        case .cloudServicePermissionDenied:
            print("User has not allowed access to cloud service information.")
            errorMessage = "User has not allowed access to cloud service information."
        case .cloudServiceNetworkConnectionFailed:
            print("The device could not connect to the network.")
            errorMessage = "The device could not connect to the network."
        case .cloudServiceRevoked:
            print("User has revoked permission to use this cloud service.")
            errorMessage = "User has revoked permission to use this cloud service."
        case .privacyAcknowledgementRequired:
            print("The user needs to acknowledge Apple’s privacy policy.")
            errorMessage = "The user needs to acknowledge Apple’s privacy policy."
        case .unauthorizedRequestData:
            print("The app is attempting to use SKPayment’s requestData property, but does not have the appropriate entitlement.")
            errorMessage = "The app is attempting to use SKPayment’s requestData property, but does not have the appropriate entitlement."
        case .invalidOfferIdentifier:
            print("The specified subscription offer identifier is not valid.")
            errorMessage = "The specified subscription offer identifier is not valid."
        case .invalidSignature:
            print("The cryptographic signature provided is not valid.")
            errorMessage = "The cryptographic signature provided is not valid."
        case .missingOfferParams:
            print("One or more parameters from SKPaymentDiscount is missing.")
            errorMessage = "One or more parameters from SKPaymentDiscount is missing."
        case .invalidOfferPrice:
            print("invalidOfferPrice")
            errorMessage = "invalidOfferPrice"
        case .noProductIDsFound:
            print("noProductIDsFound")
            errorMessage = "noProductIDsFound"
        case .productRequestFailed:
            print("productRequestFailed")
            errorMessage = "productRequestFailed"
        case .cantMakePayments:
            print("In-App Purchases are not allowed on this device.")
            errorMessage = "In-App Purchases are not allowed on this device."
        case .noPurchasesToRestore:
            print("noPurchasesToRestore")
            errorMessage = "noPurchasesToRestore"
        case .cantReadReceipt:
            print("cantReadReceipt")
            errorMessage = "cantReadReceipt"
        case .productPurchaseFailed:
            print("productPurchaseFailed")
            errorMessage = "productPurchaseFailed"
        case .refreshReceiptFailed:
            print("refreshReceiptFailed")
            errorMessage = "refreshReceiptFailed"
        case .receiveRestoredTransactionsFailed:
            print("receiveRestoredTransactionsFailed")
            errorMessage = "receiveRestoredTransactionsFailed"
        case .notActivated:
            print("Adapty SDK is not activated.")
            errorMessage = "Adapty SDK is not activated."
        case .badRequest:
            print("badRequest")
            errorMessage = "badRequest"
        case .serverError:
            print("serverError")
            errorMessage = "serverError"
        case .networkFailed:
            print("networkFailed")
            errorMessage = "networkFailed"
        case .decodingFailed:
            print("decodingFailed")
            errorMessage = "decodingFailed"
        case .encodingFailed:
            print("encodingFailed")
            errorMessage = "encodingFailed"
        case .analyticsDisabled:
            print("analyticsDisabled")
            errorMessage = "analyticsDisabled"
        case .wrongParam:
            print("Wrong parameter was passed.")
            errorMessage = "Wrong parameter was passed."
        case .activateOnceError:
            print("It is not possible to call .activate method more than once.")
            errorMessage = "It is not possible to call .activate method more than once."
        case .profileWasChanged:
            print("The user profile was changed during the operation.")
            errorMessage = "The user profile was changed during the operation."
        case .unsupportedData:
            print("unsupportedData")
            errorMessage = "unsupportedData"
        case .persistingDataError:
            print("persistingDataError")
            errorMessage = "persistingDataError"
        case .operationInterrupted:
            print("operationInterrupted")
            errorMessage = "operationInterrupted"
        }
        return errorMessage
    }
}
