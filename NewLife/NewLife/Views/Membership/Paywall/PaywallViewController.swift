//
//  PaywallViewController.swift
//  Tawazon
//
//  Created by mac on 07/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import Dispatch
import Adapty

class PaywallViewController: BasePremiumViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sectionsStackView: UIStackView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var closeButton: CircularButton!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var viewTitleWithBGLabel: PaddingLabel!
    
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var subscriptionViewTitleLabel: UILabel!
    
    @IBOutlet weak var promoButton: UIButton!
    
    @IBOutlet weak var bestPlanView: GradientView!
    @IBOutlet weak var bestPlanHeaderLabel: UILabel!
    @IBOutlet weak var bestPlanTitleLabel: UILabel!
    @IBOutlet weak var pricesStack: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var subscribeButton: GradientButton!
    
    @IBOutlet weak var plansNoteLabel: UILabel!
    @IBOutlet weak var allPlansButton: UIButton!
    @IBOutlet weak var dividerView: GradientView!
    
    @IBOutlet weak var featuresView: UIView!
    @IBOutlet weak var featuresViewTitleLabel: UILabel!
    
    @IBOutlet weak var premiumPlanLabel: UILabel!
    @IBOutlet weak var freePlanLabel: UILabel!
    
    @IBOutlet weak var featuresTable: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var restorePurchasesButton: UIButton!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    
    var allPlansData = BasePremiumVM()
    
    var darkView: Bool?{
        didSet{
            initialize()
        }
    }
    
    var features: [FeatureItem]? {
        didSet {
            LoadingHud.shared.hide(animated: true)
        }
    }
    
    var plans: [PremiumPurchaseCellVM]? {
        didSet {
            setBestPlanData()
            self.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        darkView = RemoteConfigManager.shared.bool(forKey: .premuimPage6DarkTheme)
//        initialize()
        SKPaymentQueue.default().add(self)
//        fetchData()
        adaptyGetPaywallDetails()
//        fillData()
        TrackerManager.shared.sendOpenPremiumEvent(viewName: Self.identifier)
    }
    

    private func initialize() {
        self.view.backgroundColor = darkView! ? .darkIndigoTwo : .ghostWhite
        
        scrollView.backgroundColor = .clear
        
        headerImageView.image = darkView! ? UIImage(named: "PaywallHeaderDark") : UIImage(named: "PaywallGradientBg")
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.clipsToBounds = false
        headerImageView.backgroundColor = .clear
        headerImageViewHeight.constant = darkView! ? 209 : 260
        
        sectionsStackView.backgroundColor = .clear
        
        headerView.backgroundColor = .clear
        
        
        
        backgroundImageView.image = UIImage(named: "PaywallBackgroundImage")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.backgroundColor = .clear
        backgroundImageView.clipsToBounds = false
        
        closeButton.backgroundColor = darkView! ? .black.withAlphaComponent(0.24) : .eastSide.withAlphaComponent(0.09)
        closeButton.setImage(UIImage(named: "Cancel"), for: .normal)
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
        
        
        subscriptionView.backgroundColor = .clear
        
        subscriptionViewTitleLabel.font = .munaBoldFont(ofSize: 24)
        subscriptionViewTitleLabel.textAlignment = .center
        subscriptionViewTitleLabel.numberOfLines = 0
        subscriptionViewTitleLabel.lineBreakMode = .byWordWrapping
        subscriptionViewTitleLabel.textColor =  darkView! ? .white : .darkIndigoTwo
        subscriptionViewTitleLabel.text = "paywallSubscriptionTitle".localized
        
        promoButton.backgroundColor = darkView! ? .white.withAlphaComponent(0.08) : .white
        promoButton.layer.cornerRadius = 20
        promoButton.titleLabel?.font = .munaBoldFont(ofSize: 20)
        promoButton.tintColor = darkView! ? .white.withAlphaComponent(0.32) : .darkIndigoTwo.withAlphaComponent(0.4)
        promoButton.setTitle("paywallPromoButton".localized, for: .normal)
        
        bestPlanView.layer.cornerRadius = 24
        bestPlanView.clipsToBounds = true
        bestPlanView.backgroundColor = darkView! ? .clear : .ghostWhiteTwo
        
        
        bestPlanHeaderLabel.backgroundColor = darkView! ? .governorBay : .mediumPurple
        bestPlanHeaderLabel.layer.cornerRadius = 16.0
        bestPlanHeaderLabel.roundCorners(corners: (Language.language == .arabic ? .bottomLeft : .bottomRight) , radius: 16)
        bestPlanHeaderLabel.textColor = .white
        bestPlanHeaderLabel.font = .munaBoldFont(ofSize: 18)
        bestPlanHeaderLabel.text = "paywallBestPlanTitle".localized
        bestPlanHeaderLabel.textAlignment = .center
        
        bestPlanTitleLabel.font = .munaBoldFont(ofSize: 20)
        bestPlanTitleLabel.textColor = darkView! ? .white : .darkIndigoTwo
        
        priceLabel.font = .munaFont(ofSize: 24)
        priceLabel.textColor = darkView! ? .white : .darkIndigoTwo
        priceLabel.textAlignment = Language.language == .english ? .right : .left
        
        subPriceLabel.font = .munaFont(ofSize: 15)
        subPriceLabel.textColor = darkView! ? .white.withAlphaComponent(0.56) : .darkIndigoTwo.withAlphaComponent(0.56)
        subPriceLabel.textAlignment = Language.language == .english ? .left : .right
        
        discountLabel.font = .munaBoldFont(ofSize: 15)
        discountLabel.textColor = darkView! ? .lavenderBlue : .slateBlue
        
        subscribeButton.roundCorners(corners: .allCorners, radius: 16)
        subscribeButton.layer.cornerRadius = 22
        subscribeButton.applyGradientColor(colors: [UIColor.slateBlue.cgColor, UIColor.deepLilac.cgColor], startPoint: .right, endPoint: .left)
        subscribeButton.titleLabel?.font = .munaBoldFont(ofSize: 22)
        subscribeButton.tintColor = .white
        
        plansNoteLabel.font = .munaFont(ofSize: 12)
        plansNoteLabel.numberOfLines = 0
        plansNoteLabel.lineBreakMode = .byWordWrapping
        plansNoteLabel.textColor = darkView! ? .white.withAlphaComponent(0.71) : .darkIndigoTwo.withAlphaComponent(0.71)
        plansNoteLabel.text = "paywallPlansNoteLabel".localized
        plansNoteLabel.textAlignment = .center
        
        allPlansButton.titleLabel?.font = .munaBoldFont(ofSize: 20)
        allPlansButton.tintColor = darkView! ? .lavenderBlue : .slateBlue
        allPlansButton.setTitle("paywallAllPlansButton".localized, for: .normal)
        
        dividerView.backgroundColor = .clear
        dividerView.applyGradientColor(colors: [UIColor.linkWater.withAlphaComponent(0).cgColor,UIColor.linkWater.cgColor, UIColor.linkWater.cgColor, UIColor.linkWater.withAlphaComponent(0).cgColor], startPoint: .left, endPoint: .right)
        
        featuresView.backgroundColor = .clear
        
        featuresViewTitleLabel.font = .munaBoldFont(ofSize: 20)
        featuresViewTitleLabel.textAlignment = .center
        featuresViewTitleLabel.textColor = darkView! ? .white : .black
        featuresViewTitleLabel.text = "paywallFeaturesViewTitle".localized
    
        premiumPlanLabel.font = .munaBoldFont(ofSize: 17)
        premiumPlanLabel.textAlignment = .center
        premiumPlanLabel.numberOfLines = 0
        premiumPlanLabel.lineBreakMode = .byWordWrapping
        premiumPlanLabel.textColor = darkView! ? .white : .black
        premiumPlanLabel.text = "paywallPremiumPlanLabel".localized
        
        freePlanLabel.font = .munaBoldFont(ofSize: 17)
        freePlanLabel.textAlignment = .center
        freePlanLabel.numberOfLines = 0
        freePlanLabel.lineBreakMode = .byWordWrapping
        freePlanLabel.textColor = darkView! ? .white : .black
        freePlanLabel.text = "paywallFreePlanLabel".localized
    
        featuresTable.backgroundColor = .clear
        featuresTable.allowsSelection = false
        featuresTable.separatorColor = .linkWater
    
        restorePurchasesButton.setAttributedTitle(restorePurchasesButtonAttributeText(), for: .normal)
        
        

        noteLabel.font = .munaFont(ofSize: 12)
        noteLabel.numberOfLines = 0
        noteLabel.lineBreakMode = .byWordWrapping
        noteLabel.textColor = darkView! ? .white.withAlphaComponent(0.71) : .darkIndigoTwo.withAlphaComponent(0.71)
        noteLabel.text = "paywallNoteLabel".localized
        noteLabel.textAlignment = .center
        
        
        privacyButton.titleLabel?.font = .munaFont(ofSize: 14)
        privacyButton.tintColor = darkView! ? .white : .darkIndigoTwo
        privacyButton.setTitle("paywallPrivacyButton".localized, for: .normal)
        
        pointView.layer.cornerRadius = 2
        pointView.backgroundColor = .gainsboro.withAlphaComponent(0.3)
        
        termsAndConditionsButton.titleLabel?.font = .munaFont(ofSize: 14)
        termsAndConditionsButton.tintColor = darkView! ? .white : .darkIndigoTwo
        termsAndConditionsButton.setTitle("paywallTermsAndConditionsButton".localized, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bestPlanView.gradientBorder(width: 1, colors: [.royalBlue, .mediumOrchid, .rockBlue], startPoint: .topLeft, endPoint: .bottomRight, andRoundCornersWithRadius: 24)
        fetchAllPlansData()
    }
    
    private func adaptyGetPaywallDetails(){
        Adapty.getPaywall("Premium6", locale: "en") { result in
            switch result {
            case let .success(paywall):
                    // the requested paywall
                print("paywall: \(paywall)")
                Adapty.getPaywallProducts(paywall: paywall) { result in
                    switch result {
                    case let .success(products):
                        // the requested products array
                        print("products: \(products)")
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
    private func fetchData(){
        LoadingHud.shared.show(animated: true)

        data.getPremiumPageDetails(premiumId: 9, service: MembershipServiceFactory.service(), completion: { (error) in
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
        let sharedData = BasePremiumVM.shared
        self.subscribeButton.setTitle(sharedData.premiumDetails?.premiumPage.continueLabel, for: .normal)

        self.features = sharedData.premiumDetails?.premiumPage.featureItems
        self.plans = sharedData.plansArray
    }
    
    private func fetchAllPlansData(){
        if allPlansData.plansArray.count == 0{
            allPlansData.getPremiumPageDetails(premiumId: 11, service: MembershipServiceFactory.service(), completion: { (error) in
                if error == nil{
                    return
                }
            })
        }
    }
    
    private func reloadData(){
        featuresTable.reloadData()
        tableHeight.constant = CGFloat(72 * (self.features?.count ?? 0))
        featuresTable.layoutIfNeeded()
        featuresTable.layoutSubviews()
    }
    
    private func setBestPlanData(){
        if let bestPlan = plans?.first{
            bestPlan.isSelected = true
            bestPlanTitleLabel.text = bestPlan.title
            priceLabel.text = bestPlan.price
            subPriceLabel.text = "(\(bestPlan.monthlyPrice ?? "")\("paywallMonthlyString".localized))"
            if bestPlan.savingAmount > 0{
                if Language.language == .english{
                    discountLabel.text = "\("paywallSavingLabel".localized) \(bestPlan.savingAmount ?? 0)%"
                }else{
                    discountLabel.attributedText = discountLabelAttributeText(plan: bestPlan)
                }
            }
        }
    }
    
    private func restorePurchasesButtonAttributeText() -> NSMutableAttributedString {
        
        let restorePart1 = "paywallRestoreButtonPart1".localized
        let restorePart2 = "paywallRestoreButtonPart2".localized
        let allText = String(format: "%@ %@", restorePart1, restorePart2)
        let color : UIColor = darkView! ? .lavenderBlue : .slateBlue
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.munaFont(ofSize: 17), .foregroundColor: color,.kern: 0.0])
        
        if let part2Range = allText.range(of: restorePart2) {
            attributedString.addAttributes([.font: UIFont.munaBoldFont(ofSize: 20)], range: part2Range.nsRange(in: allText))
        }
        return attributedString
    }
    
    private func discountLabelAttributeText(plan: PremiumPurchaseCellVM) -> NSMutableAttributedString {
        
        let discountPart1 = "paywallSavingLabel".localized
        let savingAmountPart2 = "\(plan.savingAmount ?? 0)%"
        let allText = String(format: "%@ %@", discountPart1, savingAmountPart2)
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.munaFont(ofSize: 15),.kern: 0.0])
        
        if let part2Range = allText.range(of: savingAmountPart2) {
            attributedString.addAttributes([.font: UIFont.munaBoldFont(ofSize: 15, language: .english)], range: part2Range.nsRange(in: allText))
        }
        return attributedString
    }
    
    @IBAction func promoCodeButtonTapped(_ sender: UIButton) {
        // open offerCode sheet
        let paymentQueue = SKPaymentQueue.default()
            if #available(iOS 14.0, *) {
                paymentQueue.presentCodeRedemptionSheet()
            }
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        if let bestPlan = plans?.first{
            purchaseAction(product: BasePremiumVM.shared.products[bestPlan.priority - 1])
        }
        
    }
    
    @IBAction func allPlansButtonTapped(_ sender: UIButton) {
        openPaywallAllPlansViewController(data: allPlansData)
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: UIButton) {
        openPrivacyViewController(type: .privacyPolicy)
    }
    
    @IBAction func termsAndConditionsButtonTapped(_ sender: UIButton) {
        openPrivacyViewController(type: .termsAndConditions)
    }
    
    private func openPaywallAllPlansViewController(data: BasePremiumVM)  {
        let viewController = PaywallAllPlansViewController.instantiate(nextView: .dimiss, data: data)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openPrivacyViewController(type: PrivacyViewController.ViewType)  {
        let viewController = PrivacyViewController.instantiate(viewType: type)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction override func cancelButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendClosePremiumEvent(viewName: Self.identifier)
        super.cancelButtonTapped(sender)
        
    }
}

extension PaywallViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.features?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaywallFeaturesTableViewCell.identifier) as! PaywallFeaturesTableViewCell
        
        cell.feature = self.features?[indexPath.row]
        
        return cell
    }
    
}


extension PaywallViewController {
    
    class func instantiate(nextView: NextView) -> PaywallViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: PaywallViewController.identifier) as! PaywallViewController
        viewController.nextView = nextView
        return viewController
    }
}
