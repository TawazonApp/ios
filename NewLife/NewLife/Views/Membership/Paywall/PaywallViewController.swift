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
import AudioToolbox

class PaywallViewController:GeneralBasePaywallViewController {

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
    @IBOutlet weak var discountNoteLabel: UILabel!
    @IBOutlet weak var subscribeButton: GradientButton!
    
    
    @IBOutlet weak var plansNoteLabel: UILabel!
    @IBOutlet weak var plansPriceNoteLabel: UILabel!
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
    
    override var useAdaptySDK: Bool?{
        didSet{
            if useAdaptySDK ?? false{ // use adapty RC
                adaptyGetPaywallDetails()
            }else{
                SKPaymentQueue.default().add(self)
                sharedData = BasePremiumVM.shared
                fillData()
            }
        }
    }
    
    var features: [FeatureItem]? {
        didSet {
            LoadingHud.shared.hide(animated: true)
        }
    }
    
    override var plans: [PremiumPurchaseCellVM]? {
        didSet {
            setBestPlanData()
            self.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenLoad, payload: nil)
        darkView = RemoteConfigManager.shared.bool(forKey: .premuimPage6DarkTheme)
        useAdaptySDK = RemoteConfigManager.shared.bool(forKey: .useAdaptySDK)

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
        
        discountLabel.font = .munaBoldFont(ofSize: 24)
        discountLabel.textColor = .slateBlue
        discountLabel.textAlignment = Language.language == .english ? .left : .right
        
        discountNoteLabel.font = .munaBoldFont(ofSize: 15)
        discountNoteLabel.textColor = darkView! ? .lavenderBlue : .slateBlue
        discountNoteLabel.textAlignment = .center
        discountNoteLabel.text = ""
        
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
        
        plansPriceNoteLabel.font = .munaFont(ofSize: 12)
        plansPriceNoteLabel.numberOfLines = 0
        plansPriceNoteLabel.lineBreakMode = .byWordWrapping
        plansPriceNoteLabel.textColor = darkView! ? .white.withAlphaComponent(0.71) : .darkIndigoTwo.withAlphaComponent(0.71)
        plansPriceNoteLabel.text = ""
        plansPriceNoteLabel.textAlignment = .center
        
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
    
    private func fetchAllPlansData(){
            if allPlansData.plansArray.count == 0{
                allPlansData.getPremiumPageDetails(premiumId: 11, service: MembershipServiceFactory.service(), completion: { (error) in
                    if error == nil{
                        return
                    }
                })
            }
        }
    
    private func adaptyGetPaywallDetails(){
        LoadingHud.shared.show(animated: true)
        paywallVM.fetchPaywallDetails(id: "Premium6BestPlan"){
            error in
            LoadingHud.shared.hide(animated: true)
            if error == nil{
                self.fillPaywallData()
                return
            }
            self.showErrorMessage(message: error?.localizedDescription ?? "generalErrorMessage".localized)
        }
    }
    
    private func fillPaywallData(){
        if let data = paywallVM.paywall{
            self.subscribeButton.setTitle((data.remoteConfig?["page"] as? [String:Any])?["continueLabel"] as? String, for: .normal)

            self.features = self.paywallVM.paywallDetails?.premiumPage.featureItems
            
            if let adaptyProducts = paywallVM.products?.map({
                return $0.product
            }){
                self.products = adaptyProducts
            }
            self.plans = self.paywallVM.plansArray
        }
    }
    
    private func fillData(){
        if let sharedData = sharedData{
            self.subscribeButton.setTitle(sharedData.premiumDetails?.premiumPage.continueLabel, for: .normal)

            self.features = sharedData.premiumDetails?.premiumPage.featureItems
            self.plans = sharedData.plansArray
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
            subPriceLabel.text = "(\(bestPlan.monthlyPrice ?? "")\("paywallMonthlyString".localized))"
            
            if let bestPlanProduct = self.products?.first{
                if let introOffer = bestPlanProduct.introductoryDiscount, (bestPlanProduct.introductoryOfferEligibility == .eligible){
                    // show Intro offer info
                    setOfferData(bestPlan: bestPlan, offerPrice: introOffer.price as NSDecimalNumber, productPrice: bestPlanProduct.skProduct.price, locale: bestPlanProduct.skProduct.priceLocale, promoOffer: false)
                } else if let offer = bestPlanProduct.discounts.first, bestPlanProduct.promotionalOfferEligibility{
                    setOfferData(bestPlan: bestPlan, offerPrice: offer.price as NSDecimalNumber, productPrice: bestPlanProduct.skProduct.price, locale: bestPlanProduct.skProduct.priceLocale, promoOffer: true)
                } else{
                    priceLabel.text = bestPlan.price
                }
            }
        }
    }
    
    private func setOfferData(bestPlan: PremiumPurchaseCellVM, offerPrice: NSDecimalNumber, productPrice: NSDecimalNumber, locale: Locale, promoOffer: Bool){
        let attributedPrice: NSMutableAttributedString = NSMutableAttributedString(string: "\(bestPlan.price!)", attributes: [.font: UIFont.munaFont(ofSize: 16)])
        attributedPrice.addAttribute(NSAttributedString.Key.strikethroughStyle, value: Language.language == .arabic ? 5 : 2, range: NSRange(location: 0, length: attributedPrice.length))
        priceLabel.attributedText = attributedPrice
        let offerPriceString = getPriceString(price: offerPrice, locale: locale)
        discountLabel.text = offerPriceString
        var discountNote = promoOffer ? "promotionalDiscountNoteLabel".localized : "introductoryDiscountNoteLabel".localized
        let discountPercentage = (Double(truncating: productPrice) - Double(truncating: offerPrice)) / Double(truncating: productPrice) * 100
        discountNote = String(format: discountNote, "\(Int(discountPercentage))%")
        discountNoteLabel.text = discountNote
        plansPriceNoteLabel.text = String(format: "plansPriceNoteLabel".localized, offerPriceString, bestPlan.price)
    }
    
    func getPriceString(price: NSDecimalNumber, locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        return formatter.string(from: price) ?? ""
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
 
    @IBAction func allPlansButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenAllPlans, payload: nil)
        openPaywallAllPlansViewController(data: allPlansData)
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenPolicy, payload: nil)
        openPrivacyViewController(type: .privacyPolicy)
    }
    
    @IBAction func termsAndConditionsButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenTerms, payload: nil)
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
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenSkip, payload: nil)
        super.cancelButtonTapped(sender)
        
    }
    
    override func restorePurchaseButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.paywallScreenRestore, payload: nil)
        super.restorePurchaseButtonTapped(sender)
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
