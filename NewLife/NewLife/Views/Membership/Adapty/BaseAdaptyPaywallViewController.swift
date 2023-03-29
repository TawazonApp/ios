//
//  BaseAdaptyPaywallViewController.swift
//  Tawazon
//
//  Created by mac on 19/03/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit
import Adapty
import AudioToolbox

class BaseAdaptyPaywallViewController: HandleErrorViewController {

    var paywallVM = AdaptyPaywallVM()
    
    var products: [AdaptyPaywallProduct]?
    
    var nextView: NextView = .dimiss
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func goToNextViewController() {
        if nextView == .mainViewController {
        } else {
            SystemSoundID.play(sound: .Sound1)
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func restorePurchaseButtonTapped(_ sender: UIButton) {
        LoadingHud.shared.show(animated: true)
        self.restorePurchases()
    }
    
    func purchaseAction(product: AdaptyPaywallProduct?){
        if let product = product{
            LoadingHud.shared.show(animated: true)
            paywallVM.makePurchase(product: product){
                (profile, error, errorMessage) in
                LoadingHud.shared.hide(animated: true)
                if error != nil{
                    let errorDescription = self.paywallVM.errorHandling(error: error!)
                    self.showErrorMessage(message: errorDescription ?? "generalErrorMessage".localized)
                    return
                }
                self.goToNextViewController()
            }
        }
        
    }
    func restorePurchases() {
        paywallVM.restorePurchases(){
            (profile, error, errorMessage) in
            LoadingHud.shared.hide(animated: true)
            if error != nil{
                let errorDescription = self.paywallVM.errorHandling(error: error!)
                self.showErrorMessage(message: errorDescription ?? "generalErrorMessage".localized)
                return
            }
            self.goToNextViewController()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendClosePremiumEvent(viewName: Self.identifier)
        
        if nextView == .mainViewController {
            TrackerManager.shared.sendSkipPremiumEvent()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
