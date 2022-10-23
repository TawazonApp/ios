//
//  Premium4ViewController.swift
//  Tawazon
//
//  Created by mac on 16/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox
import StoreKit
import Dispatch
import SwiftyStoreKit

class Premium4ViewController: BasePremiumViewController {

    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var headerTitlePart1Label: UILabel!
    @IBOutlet weak var headerTitlePart2Label: GradientLabel!
    @IBOutlet weak var headerTitlePart3Label: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imagesContainer: ImagesContainerView!
    @IBOutlet weak var plansContainer: PlansView!
    @IBOutlet weak var purchaseButton: GradientButton!
    @IBOutlet weak var restorePurchasesButton: UIButton!
    @IBOutlet weak var promoCodeButton: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    
    var features: [FeatureItem]? {
        didSet {
            imagesContainer.images = features
            fetchPlans()
        }
    }
    
    var plans: [PremiumPurchaseCellVM]? {
        didSet {
            plansContainer.plans = plans
            LoadingHud.shared.hide(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        SKPaymentQueue.default().add(self)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.fetchData()
        }
        TrackerManager.shared.sendOpenPremiumEvent(viewName: Self.identifier)
    }
    
    private func fetchData(){
        LoadingHud.shared.show(animated: true)
        
        data.getPremiumPageDetails(premiumId: premiumPageIds.premium4.rawValue, service: MembershipServiceFactory.service(), completion: { (error) in
            if error == nil{
                self.purchaseButton.setTitle(self.data.premiumDetails?.premiumPage.continueLabel, for: .normal)
                
                self.features = self.data.premiumDetails?.premiumPage.featureItems
                self.noteLabel.text = self.data.premiumDetails?.premiumPage.content
                return
            }
            self.showErrorMessage( message: error?.localizedDescription ?? "generalErrorMessage".localized)
            LoadingHud.shared.hide(animated: true)
        })
    }
    private func setData(){
        
    }
    private func fetchPlans(){
        data.fetchPremiumPurchaseProducts(completion: { (error) in
            if error == nil{
                self.plans = self.data.plansArray
                return
            }
            self.showErrorMessage( message: error?.localizedDescription ?? "generalErrorMessage".localized)
            LoadingHud.shared.hide(animated: true)
        })
    }
    private func initialize() {
        imagesContainer.delegate = self
        view.clearLabels()
        
        view.backgroundColor = UIColor.veniceBlue
        
        headerView.applyGradientColor(colors: [UIColor.veniceBlue.withAlphaComponent(0.0).cgColor, UIColor.veniceBlue.withAlphaComponent(0.71).cgColor, UIColor.veniceBlue.cgColor], startPoint: .bottom, endPoint: .top)
        
        headerTitlePart1Label.font = UIFont.munaFont(ofSize: 18.0)
        headerTitlePart1Label.text = "premium4TitleLabelPart1".localized
        headerTitlePart1Label.textColor = .white
        
        headerTitlePart2Label.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.freeSpeechBlue.cgColor], startPoint: .top, endPoint: .bottom)
        headerTitlePart2Label.text = "PLUS"
        headerTitlePart2Label.textColor = .white
        headerTitlePart2Label.layer.cornerRadius = 5
        
        headerTitlePart3Label.font = UIFont.munaBoldFont(ofSize: 32.0)
        headerTitlePart3Label.textColor = UIColor.white
        headerTitlePart3Label.numberOfLines = 0
        headerTitlePart3Label.lineBreakMode = .byWordWrapping
        headerTitlePart3Label.text = "premium4TitleLabelPart3".localized
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        cancelButton.isHidden = false
        
        purchaseButton.layer.cornerRadius = 20
        purchaseButton.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .left, endPoint: .right)
        purchaseButton.setTitle("premium4PurchaseButtonTitle".localized, for: .normal)
        purchaseButton.tintColor = .white
        purchaseButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
        
        restorePurchasesButton.setTitle("restorePurchasesButtonTitle".localized, for: .normal)
        restorePurchasesButton.titleLabel?.font = UIFont.munaFont(ofSize: 13)
        restorePurchasesButton.tintColor = UIColor.white
        
        promoCodeButton.setTitle("promoCodeButtonTitle".localized, for: .normal)
        promoCodeButton.titleLabel?.font = UIFont.munaFont(ofSize: 13)
        promoCodeButton.tintColor = UIColor.white
        
        noteLabel.font = UIFont.munaFont(ofSize: 12.0)
        noteLabel.textColor = UIColor.white
        noteLabel.layer.opacity = 0.71
//        noteLabel.text = "premium4DefaultPurchaseDescription".localized
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        print("plansContainer.selectedPlan: \(plansContainer.selectedPlan), \(data.products[plansContainer.selectedPlan].localizedTitle)")
        purchaseAction(product: data.products[plansContainer.selectedPlan])
    }
    @IBAction func promoCodeButtonTapped(_ sender: UIButton) {
        // open offerCode sheet
        let paymentQueue = SKPaymentQueue.default()
            if #available(iOS 14.0, *) {
                paymentQueue.presentCodeRedemptionSheet()
            }
    }
    
//    @IBAction func restorePurchaseButtonTapped(_ sender: UIButton) {
//        LoadingHud.shared.show(animated: true)
//        restorePurchase(completion: {
//            LoadingHud.shared.hide(animated: true)
//        })
//    }
    
//    private func restorePurchase(completion: @escaping () -> Void) {
//        if SwiftyStoreKit.localReceiptData != nil {
//            uploadPurchaseReceipt(price: "", currancy: "", completion: completion)
//            return
//        }
//
//        SwiftyStoreKit.restorePurchases { [weak self] (results) in
//            guard SwiftyStoreKit.localReceiptData != nil else {
//                completion()
//                return
//            }
//            self?.uploadPurchaseReceipt(price: "", currancy: "",completion: completion)
//        }
//    }
    
    @IBAction override func cancelButtonTapped(_ sender: UIButton) {
        super.cancelButtonTapped(sender)
        if nextView == .mainViewController {
        } else {
            TrackerManager.shared.sendClosePremiumEvent(viewName: Self.identifier)
        }
    }
}
extension Premium4ViewController {
    
    class func instantiate(nextView: NextView) -> Premium4ViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Premium4ViewController.identifier) as! Premium4ViewController
        viewController.nextView = nextView
        return viewController
    }
}


extension Premium4ViewController : ImagesContainerDelegate{
    func updateHeaderTitle(item: Int) {
        if let image = features?[item]{
            self.headerTitlePart3Label.text = image.title
        }
        
    }
}
