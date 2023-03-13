//
//  PaywallAllPlansViewController.swift
//  Tawazon
//
//  Created by mac on 11/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import Dispatch
import Adapty

class PaywallAllPlansViewController: BasePremiumViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var closeButton: CircularButton!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var viewTitleWithBGLabel: PaddingLabel!
    @IBOutlet weak var plansView: PaywallPlansView!
    @IBOutlet weak var featuresTitle: UILabel!
    @IBOutlet weak var featuresTable: UITableView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var subscribeButton: GradientButton!
    
    var darkView: Bool?{
        didSet{
            initialize()
//            fillData()
        }
    }
    var paywall: AdaptyPaywall?{
        didSet{
            fillPaywallData()
        }
    }
    var products: [AdaptyPaywallProduct]?{
        didSet{
            
        }
    }
    var features: [FeatureItem]? {
        didSet {
            LoadingHud.shared.hide(animated: true)
        }
    }
    
    var plans: [PremiumPurchaseCellVM]? {
        didSet {
            plansView.plans = plans
            self.reloadData()
        }
    }
    override var data: BasePremiumVM{
        didSet{
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        darkView = RemoteConfigManager.shared.bool(forKey: .premuimPage6DarkTheme)
        SKPaymentQueue.default().add(self)
//        fetchData()
        
        adaptyGetPaywallDetails()
        TrackerManager.shared.sendOpenPremiumEvent(viewName: Self.identifier)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    private func initialize() {
        self.view.backgroundColor = darkView! ? .darkIndigoTwo : .ghostWhite
        
        topView.backgroundColor = .clear
        
        backgroundImageView.image = darkView! ? UIImage(named: "PaywallHeaderDark") : UIImage(named: "PaywallGradientBg")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = false
        backgroundImageView.backgroundColor = .clear
        backgroundImageViewHeight.constant = darkView! ? 209 : 260
        
        closeButton.backgroundColor = darkView! ? .black.withAlphaComponent(0.24) : .eastSide.withAlphaComponent(0.09)
        let backImage =  #imageLiteral(resourceName: "BackArrow.pdf").flipIfNeeded
        closeButton.setImage(backImage, for: .normal)
        closeButton.roundCorners(corners: .allCorners, radius: 24)
        closeButton.tintColor = darkView! ? .white : .black
        
        viewTitleLabel.font = .munaFont(ofSize: 18)
        viewTitleLabel.textColor = darkView! ? .white : .darkIndigoTwo
        viewTitleLabel.text = "paywallTitlePart1".localized
        viewTitleLabel.textAlignment = .center
        
        viewTitleWithBGLabel.font = .munaBoldFont(ofSize: 18)
        viewTitleWithBGLabel.textColor = .white
        viewTitleWithBGLabel.text = "paywallTitlePart2".localized
        viewTitleWithBGLabel.textAlignment = .center
        viewTitleWithBGLabel.layer.cornerRadius = 5
        viewTitleWithBGLabel.leftInset = 5
        viewTitleWithBGLabel.rightInset = 5
        viewTitleWithBGLabel.applyGradientColor(colors: [UIColor.mediumSlateBlue.cgColor, UIColor.mediumSlateBlueTwo.cgColor], startPoint: .left, endPoint: .right)
        
        featuresTitle.font = .munaBoldFont(ofSize: 20)
        featuresTitle.textColor = darkView! ? .white : .slateBlue
        featuresTitle.text = "paywallFeatureTitle".localized
        featuresTitle.textAlignment = .center
        
        featuresTable.separatorStyle = .none
        featuresTable.backgroundColor = .clear
        featuresTable.allowsSelection = false
        featuresTable.isScrollEnabled = true
    
        noteLabel.font = .munaFont(ofSize: 12)
        noteLabel.numberOfLines = 0
        noteLabel.lineBreakMode = .byWordWrapping
        noteLabel.textColor = darkView! ? .white.withAlphaComponent(0.71) : .darkIndigoTwo.withAlphaComponent(0.71)
        noteLabel.text = "paywallNoteLabel".localized
        noteLabel.textAlignment = .center
        
        subscribeButton.roundCorners(corners: .allCorners, radius: 16)
        subscribeButton.layer.cornerRadius = 16
        subscribeButton.applyGradientColor(colors: [UIColor.slateBlue.cgColor, UIColor.deepLilac.cgColor], startPoint: .right, endPoint: .left)
        subscribeButton.titleLabel?.font = .munaBoldFont(ofSize: 22)
        subscribeButton.tintColor = .white
    }
    
    private func adaptyGetPaywallDetails(){
        Adapty.getPaywall("Premium6", locale: "en") { result in
            switch result {
            case let .success(paywall):
                    // the requested paywall
                print("paywall: \(paywall)")
                self.paywall = paywall
                Adapty.getPaywallProducts(paywall: paywall) { result in
                    switch result {
                    case let .success(products):
                        // the requested products array
                        print("products: \(products)")
                        self.products = products
                        break
                    case let .failure(error):
                        // handle the error
                        print("error: \(error)")
                        break
                    }
                }
                break
            case let .failure(error):
                    // handle the error
                print("getPaywall Error: \(error)")
                break
            }
        }
    }
    private func fillPaywallData(){
        if let paywall = self.paywall{
            self.subscribeButton.setTitle((paywall.remoteConfig?["page"] as? [String:Any])?["continueLabel"] as? String, for: .normal)
            
//            self.features = premiumDetails.premiumPage.featureItems
//            self.plans = self.data.plansArray
        }else{
            fetchData()
        }
        
    }
    private func fetchData(){
        LoadingHud.shared.show(animated: true)
        
        data.getPremiumPageDetails(premiumId: 11, service: MembershipServiceFactory.service(), completion: { (error) in
            if error == nil{
                self.subscribeButton.setTitle(self.data.premiumDetails?.premiumPage.continueLabel, for: .normal)
                
                self.features = self.data.premiumDetails?.premiumPage.featureItems
                self.plans = self.data.plansArray
                
                return
            }
            self.showErrorMessage( message: error?.localizedDescription ?? "generalErrorMessage".localized)
            LoadingHud.shared.hide(animated: true)
        })
    }
    
    private func fillData(){
        if let premiumDetails = data.premiumDetails{
            self.subscribeButton.setTitle(premiumDetails.premiumPage.continueLabel, for: .normal)
            
            self.features = premiumDetails.premiumPage.featureItems
            self.plans = self.data.plansArray
        }else{
            fetchData()
        }
        
    }
    
    private func reloadData(){
        featuresTable.reloadData()
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        print("purchaseButtonTapped")
//        purchaseAction(product: data.products[plansView.selectedPlan])
        if let product = products?.first{
            print("product: \(product)")
            Adapty.makePurchase(product: product) { result in
                switch result {
                case let .success(profile):
                    // successful purchase
                    print("profile: \(profile)")
                case let .failure(error):
                    // handle the error
                    print("error: \(error.description)")
                }
            }
        }
    }
    
    @IBAction override func cancelButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendClosePremiumEvent(viewName: Self.identifier)
        self.navigationController?.popViewController(animated: true)
    }
}

extension PaywallAllPlansViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.features?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.imageView?.image = darkView! ? UIImage(named: "PaywallFeatureAvailableDark") : UIImage(named: "PaywallFeatureAvailable")
        cell.textLabel?.font = .munaFont(ofSize: 16)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textColor = darkView! ? .white : .darkIndigoTwo
        cell.textLabel?.text = features?[indexPath.row].content
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension PaywallAllPlansViewController {
    
    class func instantiate(nextView: NextView, data: BasePremiumVM) -> PaywallAllPlansViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: PaywallAllPlansViewController.identifier) as! PaywallAllPlansViewController
        viewController.nextView = nextView
        viewController.data = data
        return viewController
    }
}
