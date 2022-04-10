//
//  PremiumViewController.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox
import SwiftyStoreKit
import StoreKit
import SafariServices

class PremiumViewController: BasePremiumViewController {
    
    @IBOutlet weak var headerView: PremiumHeaderView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var featuresView: PremiumFeaturesView!
    @IBOutlet weak var purchaseView: PremiumPurchaseView!
    @IBOutlet weak var containerView: UIScrollView!
    @IBOutlet weak var promoCodeButton: UIButton!
    @IBOutlet weak var promoCodeView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var renewablePurchaseSummaryView: PremiumRenewablePurchaseSummaryView!
    @IBOutlet weak var onTimePurchaseSummaryView: PremiumOnTimePurchaseSummaryView!

//    enum NextView {
//        case dimiss
//        case mainViewController
//    }
    
//    enum PurchaseProccessTypes {
//        case success
//        case cancel
//        case fail
//    }
    
//    var nextView: NextView = .dimiss
    var features = PremiumFeaturesVM()
//    var purchase = PremiumPurchaseVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        featuresView.features = features
        purchaseView.purchase = purchase
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.showPurchaseCorrectView()
        }
        TrackerManager.shared.sendOpenPremiumEvent()
    }
    
    private func initialize() {
        (view as? GradientView)?.applyGradientColor(colors: [UIColor.liliacTwo.cgColor, UIColor.lightBlue.cgColor], startPoint: .top, endPoint: .bottom)
        
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        cancelButton.isHidden = false
        
        purchaseView.delegate = self
        renewablePurchaseSummaryView.delegate = self
        
        stackView.removeArrangedSubview(purchaseView)
        stackView.removeArrangedSubview(renewablePurchaseSummaryView)
        stackView.removeArrangedSubview(onTimePurchaseSummaryView)
        stackView.removeArrangedSubview(promoCodeView)
        purchaseView.isHidden = true
        renewablePurchaseSummaryView.isHidden = true
        onTimePurchaseSummaryView.isHidden = true
        promoCodeView.isHidden = true
        promoCodeButton.setTitle("promoCodeButtonTitle".localized, for: .normal)
        promoCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        promoCodeButton.tintColor = UIColor.darkSlateBlue
    }
    
    private func showPurchaseCorrectView() {
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        LoadingHud.shared.show(animated: true)
        
        fetchUserInfoIfNeeded { [weak self] (userInfo, error) in
            if let error = error {
                LoadingHud.shared.hide(animated: true)
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            } else {
               
                if userInfo?.isPremium() ?? false {
                    self?.showPurchaseSummaryView()
                    LoadingHud.shared.hide(animated: true)
                } else {
                    UserInfoManager.shared.getSubscriptionsTypes(service: MembershipServiceFactory.service()) { (_, _) in
                        self?.showPurchaseProducts()
                    }
                }
            }
        }
    }
    
    private func showPurchaseSummaryView() {
        
        guard let userPremium = UserDefaults.userPremium() else {
            return
        }
        let defaultPrice: String = "-"
        let expireDate: Date? = userPremium.expireDate
        let productId = userPremium.productID ?? ""
        if expireDate == nil {
            onTimePurchaseSummaryView.data = PremiumPurchaseSummaryVM(id: productId, price: userPremium.price ?? defaultPrice, expireDate: expireDate, isTrial: userPremium.isTrialPeriod?.boolValue())
            stackView.insertArrangedSubview(onTimePurchaseSummaryView, at: 1)
            onTimePurchaseSummaryView.isHidden = false
        } else {
            renewablePurchaseSummaryView.data = PremiumPurchaseSummaryVM(id: productId, price: userPremium.price ?? defaultPrice, expireDate: expireDate, isTrial: userPremium.isTrialPeriod?.boolValue())
            stackView.insertArrangedSubview(renewablePurchaseSummaryView, at: 1)
            renewablePurchaseSummaryView.isHidden = false
        }
      
    }
    
    private func showPurchaseProducts() {
        stackView.addArrangedSubview(purchaseView)
        purchaseView.isHidden = false
        if !UserDefaults.isAnonymousUser() {
            promoCodeView.isHidden = false
            stackView.addArrangedSubview(promoCodeView)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.fetchPremiumPurchaseProducts()
        }
    }
    
    private func fetchUserInfoIfNeeded(completion: @escaping (_ userInfo: UserInfoModel?, _ error: CustomError?) -> Void) {
        
        //Fetch User Data
        UserInfoManager.shared.fetchUserInfo(service: MembershipServiceFactory.service()) {(error) in
            let userInfo = UserInfoManager.shared.getUserInfo()
            completion(userInfo, error)
        }
    }
    
    
    private func
        fetchPremiumPurchaseProducts() {
        LoadingHud.shared.show(animated: true)
        purchase.fetchPremiumPurchaseProducts { [weak self] (error) in
            LoadingHud.shared.hide(animated: true)
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                self?.sendFailToPurchaseEvent(error: error.message ?? "generalErrorMessage".localized)
            }
            self?.purchaseView.purchase = self?.purchase
        }
    }
    
//    private func openMainViewController() {
//        SystemSoundID.play(sound: .LaunchToHome)
//        (UIApplication.shared.delegate as? AppDelegate)?.pushWindowToRootViewController(viewController: MainTabBarController.instantiate(), animated: true)
//    }
    
//    private func openPrivacyViewController(viewType: PrivacyViewController.ViewType)  {
//        let viewController = PrivacyViewController.instantiate(viewType: viewType)
//        viewController.modalPresentationStyle = .custom
//        viewController.transitioningDelegate = self
//        self.present(viewController, animated: true, completion: nil)
//    }
    
    private func openLoginViewController() {
        SystemSoundID.play(sound: .Sound1)
        
        let viewController = MembershipViewController.instantiate(viewType: .login)
        
        let navigationController = NavigationController.init(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
    
    private func goToNextViewController() {
        if nextView == .mainViewController {
            openMainViewController()
        } else {
            SystemSoundID.play(sound: .Sound1)
            dismiss(animated: true, completion: nil)
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
      
    private func restorePurchase(completion: @escaping () -> Void) {
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
    
//    @IBAction func cancelButtonTapped(_ sender: UIButton) {
//        if nextView == .mainViewController {
//            TrackerManager.shared.sendSkipPremiumEvent()
//            openMainViewController()
//        } else {
//            SystemSoundID.play(sound: .Sound1)
//            TrackerManager.shared.sendClosePremiumEvent()
//            dismiss(animated: true, completion: nil)
//        }
//    }
    
    @IBAction func promoCodeButtonTapped(_ sender: UIButton) {
//        let viewController = PromoCodeViewController.instantiate()
//        viewController.modalPresentationStyle = .overCurrentContext
//        viewController.modalTransitionStyle = .crossDissolve
//        viewController.delegate = self
//        self.present(viewController, animated: true, completion: nil)
        
        // open offerCode sheet
        let paymentQueue = SKPaymentQueue.default()
            if #available(iOS 14.0, *) {
                paymentQueue.presentCodeRedemptionSheet()
            }
    }
    
    override func purchaseAction(product: SKProduct?) {

        if let item = purchase.tableArray.filter({ $0.isSelected}).first, let purchaseId = PremiumPurchase(rawValue: item.id!) {
            performPurchase(purchaseId: purchaseId, product: product)
        } else {
            goToNextViewController()
        }
    }
    
    private func openAppleCancelSubscription() {
        guard let url =  "https://support.apple.com/ar-sa/HT202039".url else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
}

extension PremiumViewController {
    
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
    
//    private func sendStartSubscriptionEvent(purchase: PurchaseDetails) {
//        let currency = purchase.product.priceLocale.currencyCode ?? ""
//        let price = purchase.product.price.doubleValue
//        let productId = purchase.productId
//        let plan = PremiumPurchase(rawValue: productId)
//        let trial = purchase.product.isTrial
//        TrackerManager.shared.sendStartSubscriptionEvent(productId: productId, plan: plan, price: price, currency: currency, trial: trial)
//    }
    
    private func sendCancelSubscriptionEvent(purchaseId: PremiumPurchase) {
        let plan = purchaseId.getPlan()
        TrackerManager.shared.sendTapCancelSubscriptionEvent(productId: purchaseId.rawValue, plan: plan)
    }
    
    private func sendFailToPurchaseEvent(error: String){
        TrackerManager.shared.sendFailToPurchaseEvent(message: error)
    }
//    func purchaseErrorMessage(error: SKError) -> String? {
//            switch error.code {
//            case .unknown:
//                return error.localizedDescription
//            case .clientInvalid: // client is not allowed to issue the request, etc.
//                return  "purchaseClientInvalid".localized
//            case .paymentCancelled: // user cancelled the request, etc.
//                return nil
//            case .paymentInvalid: // purchase identifier was invalid, etc.
//                return "purchasePaymentInvalid".localized
//            case .paymentNotAllowed: // this device is not allowed to make the payment
//                return "purchasePaymentNotAllowed".localized
//            case .storeProductNotAvailable: // Product is not available in the current storefront
//                return "purchaseStoreProductNotAvailable".localized
//            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
//                 return "purchaseCloudServicePermissionDenied".localized
//            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
//                 return "purchaseCloudServiceNetworkConnectionFailed".localized
//            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
//                return "purchaseCloudServiceRevoked".localized
//            default:
//                return  (error as NSError).localizedDescription
//            }
//
//    }
    
}

extension PremiumViewController: PremiumPurchaseViewDelegate, PremiumRenewablePurchaseSummaryViewDelegate {
 
    func openCancelSubscriptionDetails() {
        openAppleCancelSubscription()
    }
    
    func purchaseButtonTapped(product: SKProduct?) {
        purchaseAction(product: product)
    }
    
    func priacyPolicyTapped() {
        openPrivacyViewController(viewType: .privacyPolicy)
    }
    
    func termsAndConditionsTapped() {
        openPrivacyViewController(viewType: .termsAndConditions)
    }
}


extension PremiumViewController {
    
    class func instantiate(nextView: NextView) -> PremiumViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: PremiumViewController.identifier) as! PremiumViewController
        viewController.nextView = nextView
        return viewController
    }
}

extension PremiumViewController: PromoCodeViewControllerDelegate {
    func promoCodeSubmited(_ sender: PromoCodeViewController) {
        fetchUserInfo()
    }
}
