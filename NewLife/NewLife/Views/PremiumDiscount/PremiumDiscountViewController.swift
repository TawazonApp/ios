//
//  PremiumDiscountViewController.swift
//  Tawazon
//
//  Created by Shadi on 14/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox
import SwiftyStoreKit
import StoreKit
import SafariServices

class PremiumDiscountViewController: HandleErrorViewController {
    enum PurchaseProccessTypes {
        case success
        case cancel
        case fail
    }
    
    var product: SKProduct!
    var offerInfo: SubscriptionTypeItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()

        tableView.backgroundColor = UIColor.white
        tableView.backgroundView?.backgroundColor = UIColor.white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.reloadData()
        payButton.layer.cornerRadius = 16
        payButton.setTitle("premiumDiscountPayButtonTitle".localized, for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func populateData() {
        guard var discount = offerInfo.discount, discount < 1 else {
            priceLabel.text = ""
            return
        }
        discount = 1 - discount
        let price = (Float(truncating: product.price) / discount)
        let discountPrice = product.price
        let discountPriceString = getPriceString(price: discountPrice, locale: product.priceLocale)
        let priceString = getPriceString(price: NSDecimalNumber(value: price), locale: product.priceLocale)

        let part1 = "insteadOf".localized
        let part2 = "autoRenwable".localized
        let title = String(format: "%@ %@ %@ %@", discountPriceString, part1, priceString, part2)
        priceLabel.text = title
    }

    func getPriceString(price: NSDecimalNumber, locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        return formatter.string(from: price) ?? ""
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        performPurchase(purchaseId: .yearly)
    }
    
    private func performPurchase(purchaseId: PremiumPurchase) {
        LoadingHud.shared.show(animated: true)
        purchase(purchaseId: purchaseId) { [weak self] (type, error) in
            LoadingHud.shared.hide(animated: true)
            
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            } else if type == .success {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func purchase(purchaseId: PremiumPurchase, completion: @escaping (PurchaseProccessTypes, CustomError?) -> Void) {
        SwiftyStoreKit.purchaseProduct(purchaseId.rawValue, atomically: false) { [weak self] result in
            
            if case .success(let purchase) = result {
                self?.sendStartSubscriptionEvent(purchase: purchase)
               // if purchase.needsFinishTransaction {
                    self?.uploadPurchaseReceipt {
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
                    self?.sendCancelSubscriptionEvent(purchaseId: purchaseId)
                    completion(PurchaseProccessTypes.cancel, nil)
                }
            }
        }
    }
    
    private func uploadPurchaseReceipt(completion: @escaping () -> Void) {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let price = "\(product.price.doubleValue)"
        let currancy = product.priceLocale.currencyCode ?? ""
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
    
    private func sendCancelSubscriptionEvent(purchaseId: PremiumPurchase) {
        let plan = purchaseId.getPlan()
        TrackerManager.shared.sendTapCancelSubscriptionEvent(productId: purchaseId.rawValue, plan: plan)
    }
    
    private func sendStartSubscriptionEvent(purchase: PurchaseDetails) {
        let currency = purchase.product.priceLocale.currencyCode ?? ""
        let price = purchase.product.price.doubleValue
        let productId = purchase.productId
        let plan = PremiumPurchase(rawValue: productId)
        let trial = purchase.product.isTrial
        TrackerManager.shared.sendStartSubscriptionEvent(productId: productId, plan: plan, price: price, currency: currency, trial: trial)
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

extension PremiumDiscountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if offerInfo.discountCampaign?.isRamadan ?? false {
            let cell = tableView.dequeueReusableCell(withIdentifier: RamdanPremiumDiscountCell.identifier) as! RamdanPremiumDiscountCell
            cell.percentageTitle = offerInfo.discountCampaign?.title ?? ""
            cell.subTitle = offerInfo.discountCampaign?.subtitle ?? ""
            cell.imageUrl = offerInfo.discountCampaign?.image
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PremiumDiscountCell.identifier) as! PremiumDiscountCell
            cell.percentageTitle = offerInfo.discountCampaign?.title ?? ""
            cell.subTitle = offerInfo.discountCampaign?.subtitle ?? ""
            cell.imageUrl = offerInfo.discountCampaign?.image
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PremiumDiscountViewController {
    class func instantiate(product: SKProduct, offerInfo: SubscriptionTypeItem) -> PremiumDiscountViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: PremiumDiscountViewController.identifier) as! PremiumDiscountViewController
        viewController.product = product
        viewController.offerInfo = offerInfo
        return viewController
    }
}
