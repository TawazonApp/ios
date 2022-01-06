//
//  PermissionAlertView.swift
//  NewLife
//
//  Created by Shadi on 29/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit


class PermissionAlert: NSObject {
    
    static let shared = PermissionAlert()
    
    private var alertView: PermissionAlertView?
    private override init() {}
    
    func show(type: PermissionAlertView.AlertType ,animated: Bool, actionHandler: (()->Void)?, cancelHandler: (()->Void)?) {
        if alertView == nil {
            alertView = PermissionAlertView.fromNib()
            alertView!.show(type: type, animated: animated, actionHandler: actionHandler, cancelHandler: cancelHandler)
        }
    }
    
    func hide(animated: Bool,  completion: (() -> Void)? = nil) {
        
        if alertView == nil {
            completion?()
            return
        }
        
        alertView?.hide(animated: animated, completion: { [weak self] in
            self?.alertView = nil
            completion?()
        })
    }
    
}


class PermissionAlertView: UIView, NibInstantiatable {
    
    
    enum AlertType {
        case login
        case premium
        case cancelSubscription
    }
    
    typealias PermissionAlertData = (backgroundColor: UIColor, iconName: String?, title: String?, subTitle: String?, actionTitle: String, cancelTitle: String)
    
    var actionHandler: (()->Void)? = nil
    var cancelHandler:(()->Void)? = nil
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let animationDuration: TimeInterval = 0.25
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.32)
        
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.clear
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = iconImageView.frame.height/2
        iconImageView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.lbcBold(ofSize: 17, language: .arabic)
        titleLabel.tintColor = UIColor.charcoalGrey
        
        subTitleLabel.font = UIFont.kacstPen(ofSize: 20, language: .arabic)
        subTitleLabel.tintColor = UIColor.charcoalGrey
        
        actionButton.titleLabel?.font = UIFont.kacstPen(ofSize: 22)
        actionButton.tintColor = UIColor.charcoalGrey
        
        cancelButton.titleLabel?.font = UIFont.kacstPen(ofSize: 22)
        cancelButton.tintColor = UIColor.charcoalGrey
        
    }
    
    func updateStyle(type: AlertType) {
        let data = dataBy(type: type)
        contentView.backgroundColor = data.backgroundColor
        actionsView.backgroundColor = UIColor.clear
        
        iconImageView.image = (data.iconName != nil) ? UIImage(named: data.iconName!) : nil
        
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
        
        actionButton.setTitle(data.actionTitle, for: .normal)
        actionButton.backgroundColor = data.backgroundColor
        
        cancelButton.setTitle(data.cancelTitle, for: .normal)
        cancelButton.backgroundColor = data.backgroundColor
    }
    
    private func dataBy(type: AlertType) -> PermissionAlertData {
        switch type {
        case .login:
            return (backgroundColor: UIColor.veryLightBlue, iconName: "PermissionLoginAlert", title: "PermissionLoginAlertTitle".localized, subTitle: "PermissionLoginAlertBody".localized, actionTitle: "PermissionLoginAlertActionTitle".localized, cancelTitle: "PermissionLoginAlertCancelTitle".localized)
            
        case .premium:
            return (backgroundColor: UIColor.lightPink, iconName: "PermissionPremiumAlert", title: "PermissionPremiumAlertTitle".localized, subTitle: "PermissionPremiumAlertBody".localized, actionTitle: "PermissionPremiumAlertActionTitle".localized, cancelTitle: "PermissionPremiumAlertCancelTitle".localized)

        case .cancelSubscription:
        return (backgroundColor: UIColor.lightPink, iconName: "PermissionPremiumAlert", title: "CancelSubscriptionAlertTitle".localized, subTitle: "CancelSubscriptionAlertBody".localized, actionTitle: "CancelSubscriptionAlertActionTitle".localized, cancelTitle: "CancelSubscriptionlertCancelTitle".localized)
    }
    }
    
    func show(type:PermissionAlertView.AlertType, animated: Bool, actionHandler: (()->Void)?, cancelHandler: (()->Void)?) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        self.restorationIdentifier = restorationIdentifier
        updateStyle(type: type)
        keyWindow.addSubview(self)
        
        // Add constraints for `containerView`.
        ({
            let leadingConstraint = NSLayoutConstraint(item: keyWindow, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: keyWindow, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint(item: keyWindow, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: keyWindow, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            
            keyWindow.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
            }())
        
        self.cancelHandler = cancelHandler
        self.actionHandler = actionHandler
        
        if animated {
            fadeInAnimation { (finish) in }
        }
    }
    
    func hide(animated: Bool, completion: @escaping (() -> Void)) {
        if animated {
            fadeOutAnimation { [weak self] (finish) in
                self?.removeFromSuperview()
                completion()
            }
        } else {
            removeFromSuperview()
            completion()
        }
    }
    
    private func fadeInAnimation(completion: @escaping ((Bool) -> Void)) {
        self.alpha = 0.0
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            self?.alpha = 1.0
        }) { (finish) in
            completion(true)
        }
    }
    
    private func fadeOutAnimation(completion: @escaping ((Bool) -> Void)) {
        UIView.animate(withDuration: animationDuration, animations: {  [weak self] in
            self?.alpha = 0.0
        }) { (finish) in
            completion(true)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        cancelHandler?()
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        actionHandler?()
    }
}
