//
//  PromoCodeViewController.swift
//  Tawazon
//
//  Created by Shadi on 26/06/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

protocol PromoCodeViewControllerDelegate: class {
    func promoCodeSubmited(_ sender: PromoCodeViewController)
}

class PromoCodeViewController: HandleErrorViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    weak var delegate: PromoCodeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.32)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:))))
        
        containerView.layer.cornerRadius = 18
        containerView.layer.masksToBounds = true
        
        titleLabel.font = UIFont.lbcBold(ofSize: 17)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "promoViewTitle".localized
        
        textField.font = UIFont.kacstPen(ofSize: 17)
        textField.textColor = UIColor.black
        textField.placeholder = "promoViewTextFieldPlaceholder".localized
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.becomeFirstResponder()
        textField.returnKeyType = .done
        textField.delegate = self
        
        submitButton.tintColor = UIColor.black
        submitButton.titleLabel?.font = UIFont.kacstPen(ofSize: 22)
        submitButton.setTitle("submitPromoCodeButtonTitle".localized, for: .normal)
        submitButton.isEnabled = false
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        enterPromoCode(promoCode: getPromoCode())
    }
    
    private func enterPromoCode(promoCode: String) {
        LoadingHud.shared.show(animated: true)
        UserInfoManager.shared.submitPromoCode(service: MembershipServiceFactory.service(), promoCode: promoCode) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                LoadingHud.shared.hide(animated: true)
                self.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
            } else {
                self.dismiss(animated: true, completion: nil)
                self.delegate?.promoCodeSubmited(self)
            }
        }
    }
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        submitButton.isEnabled = getPromoCode().count > 0
    }
    
    @objc
    private func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        if !containerView.frame.contains(sender.location(in: view)) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func getPromoCode() -> String {
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}

extension PromoCodeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let validCode = textField.text?.count ?? 0 > 0
        if validCode {
            submitButtonTapped(submitButton)
        }
        return validCode
    }
}

extension PromoCodeViewController {
    class func instantiate() -> PromoCodeViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: PromoCodeViewController.identifier) as! PromoCodeViewController
        return viewController
    }
}
