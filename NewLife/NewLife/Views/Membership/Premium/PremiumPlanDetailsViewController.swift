//
//  PremiumPlanDetailsViewController.swift
//  Tawazon
//
//  Created by mac on 09/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import SafariServices

class PremiumPlanDetailsViewController: BasePremiumViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var headerTitlePart1: UILabel!
    @IBOutlet weak var headerTitlePart2: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentTitle: UILabel!
    
    @IBOutlet weak var planDetailsView: UIView!
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var planPriceLabel: UILabel!
    @IBOutlet weak var planTrialLabel: UILabel!
    @IBOutlet weak var planEndSubscribtionDateLabel: UILabel!
    
    @IBOutlet weak var cancelSubscribtionButton: GradientButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    @IBOutlet weak var dividerImage: UIImageView!
    
    @IBOutlet weak var planFeaturesTable: UITableView!
    
    
    var features = PremiumFeaturesVM()
    
    var purchaseData: PremiumPurchaseSummaryVM? {
        didSet{
            setData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        getPurchaseData()
    }
    
    private func initialize(){
        view.clearLabels()
        
        view.backgroundColor = .tiber
        headerImage.image = UIImage(named: "PremiumPlanDetailsHeader")
        
        logoImage.image = UIImage(named: "TawazonLogoGlyph")
        
        headerTitlePart1.font = .munaBoldFont(ofSize: 24.0)
        headerTitlePart1.textColor = .white
        headerTitlePart1.textAlignment = .center
        headerTitlePart1.text = "premiumPlanDetailsTitlePart1".localized
        
        headerTitlePart2.font = .munaFont(ofSize: 18.0)
        headerTitlePart2.textColor = .white
        headerTitlePart2.textAlignment = .center
        headerTitlePart2.numberOfLines = 0
        headerTitlePart2.lineBreakMode = .byWordWrapping
        headerTitlePart2.text = "premiumPlanDetailsTitlePart2".localized
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        cancelButton.isHidden = false
        
        contentTitle.font = .munaBoldFont(ofSize: 18.0)
        contentTitle.textColor = .lightSlateBlue
        contentTitle.text = "premiumPlanDetailsContentTitle".localized
        
        
        planDetailsView.layer.cornerRadius = 16
        planDetailsView.backgroundColor = .regalBlue
        planDetailsView.layer.borderColor = UIColor.lightSlateBlue.cgColor
        planDetailsView.layer.borderWidth = 1
        
        
        planTitleLabel.layer.cornerRadius = 16.0
        planTitleLabel.roundCorners(corners: (Language.language == .arabic ? .bottomLeft : .bottomRight) , radius: 16)
        planTitleLabel.font = UIFont.munaBoldFont(ofSize: 18.0)
        planTitleLabel.textColor = .regalBlue
        planTitleLabel.textAlignment = .center
        planTitleLabel.backgroundColor = .lightSlateBlue
        
        planPriceLabel.textColor = .lightSlateBlue
        planPriceLabel.font = UIFont.munaFont(ofSize: 24.0)
        
        planTrialLabel.font = UIFont.munaFont(ofSize: 14.0)
        planTrialLabel.textColor = .lightSlateBlue
        
        planEndSubscribtionDateLabel.textColor = .magnolia
        planEndSubscribtionDateLabel.font = UIFont.munaFont(ofSize: 18.0)
        
        cancelSubscribtionButton.layer.cornerRadius = 20
        cancelSubscribtionButton.applyGradientColor(colors: [UIColor.irisTwo.cgColor, UIColor.deepLilac.cgColor], startPoint: .left, endPoint: .right)
        cancelSubscribtionButton.tintColor = .white
        cancelSubscribtionButton.titleLabel?.font  = UIFont.munaBoldFont(ofSize: 20)
        cancelSubscribtionButton.setTitle("premiumPlanDetailsCancelSubscribtionButtonTitle".localized, for: .normal)
        
        privacyButton.tintColor = .white
        privacyButton.titleLabel?.font  = UIFont.munaFont(ofSize: 13)
        privacyButton.setTitle("premiumPlanDetailsCancelPrivacyButtonTitle".localized, for: .normal)
        
        dividerImage.image = UIImage(named: "PremiumPlanDetailsDivider")
    }

    private func getPurchaseData(){
        guard let userPremium = UserDefaults.userPremium() else {
            return
        }
        let defaultPrice: String = "-"
        let expireDate: Date? = userPremium.expireDate
        let productId = userPremium.productID ?? ""
        if expireDate == nil {
            purchaseData = PremiumPurchaseSummaryVM(id: productId, price: userPremium.price ?? defaultPrice, expireDate: expireDate, isTrial: userPremium.isTrialPeriod?.boolValue())
        } else {
            purchaseData = PremiumPurchaseSummaryVM(id: productId, price: userPremium.price ?? defaultPrice, expireDate: expireDate, isTrial: userPremium.isTrialPeriod?.boolValue())
        }
    }
    private func reloadData() {
        setData()
        planFeaturesTable.reloadData()
    }
    
    private func setData(){
        planTitleLabel.text = purchaseData?.title
        planPriceLabel.text = purchaseData?.descriptionString
        planTrialLabel.text = purchaseData?.subTitle
        planEndSubscribtionDateLabel.text = purchaseData?.expireString
        
    }
    
    @IBAction func termsButtonTapped(_ sender: UIButton) {
        openPrivacyViewController(viewType: .termsAndConditions)
    }
    
    @IBAction func cancelSubscribtionButtonTapped(_ sender: UIButton) {
        //TODO: send cancel subscribtion button tapped
        PermissionAlert.shared.show(type: PermissionAlertView.AlertType.cancelSubscription, animated: true, actionHandler: {
            PermissionAlert.shared.hide(animated: true, completion: { [weak self] in
                guard let url =  "https://support.apple.com/ar-sa/HT202039".url else {
                    return
                }
                let safariVC = SFSafariViewController(url: url)
                self?.present(safariVC, animated: true, completion: nil)
            })
        }, cancelHandler: {
            PermissionAlert.shared.hide(animated: true)
        })
    }
    func sendUnsbscribeButtonTappedEvent(){
        if purchaseData != nil{
            TrackerManager.shared.sendUnsbscribeButtonTappedEvent(productId: purchaseData!.id, name: purchaseData!.title)
        }
        
    }
}
extension PremiumPlanDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Premium1FeaturesTableViewCell.identifier) as! Premium1FeaturesTableViewCell
        cell.itemLabel.text = features.tableArray[indexPath.row].title
        return cell
    }
}
extension PremiumPlanDetailsViewController {
    
    class func instantiate(nextView: NextView) -> PremiumPlanDetailsViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: PremiumPlanDetailsViewController.identifier) as! PremiumPlanDetailsViewController
        viewController.nextView = nextView
        return viewController
    }
}
