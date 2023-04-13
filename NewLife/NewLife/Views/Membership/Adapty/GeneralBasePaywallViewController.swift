//
//  GeneralBasePaywallViewController.swift
//  Tawazon
//
//  Created by mac on 22/03/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit
import Adapty
import StoreKit
import AudioToolbox

class GeneralBasePaywallViewController: HandleErrorViewController, SKPaymentTransactionObserver {
    
    var useAdaptySDK: Bool?{
        didSet{
            if useAdaptySDK ?? false{ // use adapty RC
            }else{
                SKPaymentQueue.default().add(self)
                sharedData = BasePremiumVM.shared
            }
        }
    }
    
    var plans: [PremiumPurchaseCellVM]? {
        didSet {
        }
    }
    ///////////////
    ///
    var paywallVM = AdaptyPaywallVM()
    
    var products: [AdaptyPaywallProduct]?
    
    var nextView: NextView = .dimiss
    ///
    /////////////
    
    var sharedData: BasePremiumVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        LoadingHud.shared.show(animated: true)
        if useAdaptySDK ?? false{ // use adapty RC
            if let selectedPlanIndex = plans?.enumerated().filter({ $0.element.isSelected == true }).map({ $0.offset }).first{
                if let product = paywallVM.products?[selectedPlanIndex].product{
                    
                    TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenSubmit, payload: ["planId" : product.vendorProductId, "planName" : product.localizedTitle, "paywallName" : product.paywallName])
                    
                    paywallVM.makePurchase(product: product){
                        (profile, error, errorMessage) in
                        LoadingHud.shared.hide(animated: true)
                        if error != nil{
                            if !(errorMessage?.isEmptyWithTrim ?? true){
                                let data : PermissionAlertData = (backgroundColor: UIColor.slateBlue, iconName: "", title: errorMessage, subTitle: "".localized, bodyActionTitle: "", actionTitle: nil , cancelTitle: "deleteResponseOkButton".localized, contentColor: .white, actionTitleColor: .roseBud)
                                PermissionAlert.shared.show(type: PermissionAlertView.AlertType.generalMessage, animated: true, actionHandler: nil, cancelHandler: {
                                    PermissionAlert.shared.hide(animated: true)
                                }, typeData: data)
                            }
                            return
                        }
                        self.goToNextViewController()
                    }
                }
            }else{
                if let sharedData = sharedData{
                    if let item = BasePremiumVM.shared.plansArray.filter({ $0.isSelected}).first, let purchaseId = PremiumPurchase(rawValue: item.id!){
                        sharedData.purchase(purchaseId: purchaseId, product: sharedData.products.first){
                            (type, error) in
                            LoadingHud.shared.hide(animated: true)
                            
                            if let error = error {
                                if type == .fail{
                                    //                                self?.sendFailToPurchaseEvent(purchaseId: purchaseId,error: error.message ?? "generalErrorMessage".localized)
                                }
                                self.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                                
                            } else if type == .success {
                                self.goToNextViewController()
                            }
                        }
                    }
                }
            }
            }
            
    }
    
    @IBAction func restorePurchaseButtonTapped(_ sender: UIButton) {
        LoadingHud.shared.show(animated: true)
        if useAdaptySDK ?? false{
            paywallVM.restorePurchases(){
                (profile, error, errorMessage) in
                LoadingHud.shared.hide(animated: true)
                if error != nil{
                    if !(errorMessage?.isEmptyWithTrim ?? true){
                        let data : PermissionAlertData = (backgroundColor: UIColor.slateBlue, iconName: "", title: errorMessage, subTitle: "".localized, bodyActionTitle: "", actionTitle: nil , cancelTitle: "deleteResponseOkButton".localized, contentColor: .white, actionTitleColor: .roseBud)
                        PermissionAlert.shared.show(type: PermissionAlertView.AlertType.generalMessage, animated: true, actionHandler: nil, cancelHandler: {
                            PermissionAlert.shared.hide(animated: true)
                        }, typeData: data)
                    }
                    
                    return
                }
                self.goToNextViewController()
            }
        }else{
            if let sharedData = sharedData{
                sharedData.restorePurchase(){
                    LoadingHud.shared.hide(animated: true)
                    self.goToNextViewController()
                }
            }
        }
    }
    
    @IBAction func promoCodeButtonTapped(_ sender: UIButton) {
        if useAdaptySDK ?? false{
            paywallVM.redeemPromoCode()
        }else{
            if let sharedData = sharedData{
                sharedData.redeemPromoCode()
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendClosePremiumEvent(viewName: Self.identifier)
        
        if nextView == .mainViewController {
            TrackerManager.shared.sendSkipPremiumEvent()
            openMainViewController()
        } else {
            dismiss(animated: true, completion: nil)
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
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                
                break
            case .failed:
                if let error = transaction.error as? SKError{
                    switch error.code{
                    case .paymentCancelled:
                        print("Cancelled")
                    default:
                        break
                    }
                }
                break
            case .restored:
                
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
}
