//
//  PremiumRenewablePurchaseResultView.swift
//  NewLife
//
//  Created by Shadi on 30/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import SafariServices

protocol PremiumRenewablePurchaseSummaryViewDelegate: class {
    func openCancelSubscriptionDetails()
}

class PremiumRenewablePurchaseSummaryView: UIView {
    
    @IBOutlet weak var heaerTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageview: UIImageView!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var separatorImageview: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: PremiumRenewablePurchaseSummaryViewDelegate?
    
    var data: PremiumPurchaseSummaryVM? {
        didSet{
            fillData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        
        heaerTitleLabel.font = UIFont.lbcBold(ofSize: 17)
        heaerTitleLabel.textColor = UIColor.white
        heaerTitleLabel.text = "premiumPurchaseSummaryHeaderTitle".localized
        
        titleLabel.textColor = UIColor.darkSlateBlue
        titleLabel.font = UIFont.kacstPen(ofSize: 22)
        
        subTitleLabel.textColor = UIColor.darkSlateBlue
        subTitleLabel.font = UIFont.kacstPen(ofSize: 14)
        
        expireDateLabel.textColor = UIColor.darkFour
        expireDateLabel.font = UIFont.kacstPen(ofSize: 17)
                
        cancelButton.tintColor = UIColor.white
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        cancelButton.titleLabel?.font = UIFont.kacstPen(ofSize: 22)
        cancelButton.layer.cornerRadius = 18
        cancelButton.isHidden = data?.isCoupon ?? false
        cancelButton.setTitle("cancelPremiumRenewablePurchaseButton".localized, for: .normal)
        
        separatorImageview.image = UIImage(named: "PremiumPurchaseIcon")
    }

    private func fillData() {
        titleLabel.text = data?.title
        subTitleLabel.text = data?.subTitle
        expireDateLabel.text = data?.expireString
        iconImageview.image = data?.image
        cancelButton.isHidden = data?.isCoupon ?? false
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        PermissionAlert.shared.show(type: PermissionAlertView.AlertType.cancelSubscription, animated: true, actionHandler: {
            PermissionAlert.shared.hide(animated: true, completion: { [weak self] in
                self?.delegate?.openCancelSubscriptionDetails()
            })
        }, cancelHandler: {
            PermissionAlert.shared.hide(animated: true)
        })
    }
}
