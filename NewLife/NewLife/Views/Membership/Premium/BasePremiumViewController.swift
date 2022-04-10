//
//  BasePremiumViewController.swift
//  Tawazon
//
//  Created by mac on 16/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import AudioToolbox

enum NextView {
    case dimiss
    case mainViewController
}

class BasePremiumViewController: HandleErrorViewController {

    var purchase = PremiumPurchaseVM()
    
    var data = BasePremiumVM()
    
    var nextView: NextView = .dimiss
    
    enum PurchaseProccessTypes {
        case success
        case cancel
        case fail
    }
    
    private func fetchUserInfoIfNeeded(completion: @escaping (_ userInfo: UserInfoModel?, _ error: CustomError?) -> Void) {
        
        //Fetch User Data
        UserInfoManager.shared.fetchUserInfo(service: MembershipServiceFactory.service()) {(error) in
            let userInfo = UserInfoManager.shared.getUserInfo()
            completion(userInfo, error)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        if nextView == .mainViewController {
            TrackerManager.shared.sendSkipPremiumEvent()
            openMainViewController()
        } else {
            TrackerManager.shared.sendClosePremiumEvent()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func purchaseAction(product: SKProduct?) {
        if let item = data.plansArray.filter({ $0.isSelected}).first, let purchaseId = PremiumPurchase(rawValue: item.id!) {
            performPurchase(purchaseId: purchaseId, product: product)
        } else {
            goToNextViewController()
        }
    }
    
    private func performPurchase(purchaseId: PremiumPurchase, product: SKProduct?) {
        LoadingHud.shared.show(animated: true)
        purchase(purchaseId: purchaseId, product: product) { [weak self] (type, error) in
            LoadingHud.shared.hide(animated: true)
            
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                self?.sendFailToPurchaseEvent(error: error.message ?? "generalErrorMessage".localized)
            } else if type == .success {
                self?.goToNextViewController()
            }
        }
    }
    
    private func goToNextViewController() {
        if nextView == .mainViewController {
            openMainViewController()
        } else {
            SystemSoundID.play(sound: .Sound1)
            dismiss(animated: true, completion: nil)
        }
    }
    func openMainViewController() {
        SystemSoundID.play(sound: .LaunchToHome)
        (UIApplication.shared.delegate as? AppDelegate)?.pushWindowToRootViewController(viewController: MainTabBarController.instantiate(), animated: true)
    }
}
extension BasePremiumViewController{
    private func purchase(purchaseId: PremiumPurchase, product: SKProduct?, completion: @escaping (PurchaseProccessTypes, CustomError?) -> Void) {
        SwiftyStoreKit.purchaseProduct(purchaseId.rawValue, atomically: false) { [weak self] result in
            
            if case .success(let purchase) = result {
                self?.sendStartSubscriptionEvent(purchase: purchase)
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
                self?.sendCancelSubscriptionEvent(purchaseId: purchaseId)
                if let errorMessage = self?.purchaseErrorMessage(error: error) {
                    let errorResult = CustomError(message: errorMessage, statusCode: nil)
                    completion(PurchaseProccessTypes.fail, errorResult)
                } else {
                    completion(PurchaseProccessTypes.cancel, nil)
                }
            }
        }
    }
    
    private func uploadPurchaseReceipt(price: String, currancy: String, completion: @escaping () -> Void) {
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
    func openPrivacyViewController(viewType: PrivacyViewController.ViewType)  {
        let viewController = PrivacyViewController.instantiate(viewType: viewType)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true, completion: nil)
    }
}
//MARK: Events
extension BasePremiumViewController{
    func sendStartSubscriptionEvent(purchase: PurchaseDetails) {
        let currency = purchase.product.priceLocale.currencyCode ?? ""
        let price = purchase.product.price.doubleValue
        let productId = purchase.productId
        let plan = PremiumPurchase(rawValue: productId)
        let trial = purchase.product.isTrial
        TrackerManager.shared.sendStartSubscriptionEvent(productId: productId, plan: plan, price: price, currency: currency, trial: trial)
    }
    
    private func sendCancelSubscriptionEvent(purchaseId: PremiumPurchase) {
        let plan = purchaseId.getPlan()
        TrackerManager.shared.sendTapCancelSubscriptionEvent(productId: purchaseId.rawValue, plan: plan)
    }
    
    private func sendFailToPurchaseEvent(error: String){
        TrackerManager.shared.sendFailToPurchaseEvent(message: error)
    }
}
