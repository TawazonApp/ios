//
//  MembershipFormView.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AuthenticationServices

protocol MembershipFormViewDelegate: class {
    func forgetPasswordTapped()
    func privacyPolicyTapped()
    func showErrorMessageView(title: String?, message: String)
    func submitSucceeded()
    func facebookButtonTapped()
}

class MembershipFormView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var facbookButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    @IBOutlet weak var forgetPasswordHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appleIdButtonContainer: UIView!
    @IBOutlet weak var appleIdButtonHeightConstraint: NSLayoutConstraint!

    weak var delegate: MembershipFormViewDelegate?
    
    let cellHeight: CGFloat = (UIScreen.main.bounds.height <= 568.0) ? 50 : 60
    
    var data: MembershipFormVM! {
        didSet {
           reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.kacstPen(ofSize: 22)
        titleLabel.textColor = UIColor.white
        
        tableView.backgroundColor = UIColor.clear
        tableView.layer.cornerRadius = 18
        tableView.layer.masksToBounds = true
        
        facbookButton.backgroundColor = UIColor.facebookColor
        facbookButton.tintColor = UIColor.white
        facbookButton.titleLabel?.font = UIFont.kacstPen(ofSize: 16)
        facbookButton.layer.cornerRadius = 18
        facbookButton.layer.masksToBounds = true
        facbookButton.setTitle("facebookButtonTitle".localized, for: .normal)
        facbookButton.setImage(#imageLiteral(resourceName: "FacebookLogo.pdf"), for: .normal)
        facbookButton.centerTextAndImage(spacing: 10)
        
        
        forgetPasswordButton.tintColor = UIColor.white
        forgetPasswordButton.titleLabel?.font = UIFont.kacstPen(ofSize: 14)
        forgetPasswordButton.setTitle("forgetPasswordButtonTitle".localized, for: .normal)
        
        privacyPolicyButton.tintColor = UIColor.white
        privacyPolicyButton.setAttributedTitle(privacyPolicyAttributeText(), for: .normal)
        
        appleIdButtonHeightConstraint.constant = 0
        appleIdButtonContainer.isHidden = true
    }
    
    private func reloadData() {
        titleLabel.text = data.title
        tableView.reloadData()
        updateLayout()
        
    }
    
    private func sumbitButtonTapped() {
        
        self.endEditing(true)
        
        for cell in tableView.visibleCells {
            if let textfieldCell = cell as? MembershipTextFieldCell {
                textfieldCell.updateValidationStatus()
            }
        }
        LoadingHud.shared.show(animated: true)
        data.submit { [weak self] (error) in
            LoadingHud.shared.hide(animated: true)
            if let error = error {
                self?.delegate?.showErrorMessageView(title: nil, message: error.message ?? "generalErrorMessage".localized)
            } else {
                self?.delegate?.submitSucceeded()
            }
        }
    }
    
    private func updateLayout() {
        let tableHeight = CGFloat(data.items.count) * cellHeight
        tableHeightConstraint.constant = tableHeight
        forgetPasswordHeightConstraint.constant = (data is LoginFormVM) ? 30 : 0
        forgetPasswordButton.isHidden = !(data is LoginFormVM)
        privacyPolicyButton.isHidden = !(data is RegisterFormVM)
        addAppleIDButton()
        self.layoutIfNeeded()
        
    }
    
    private func privacyPolicyAttributeText() -> NSMutableAttributedString {
        
        let privacyPolicyPart1 = "privacyPolicyPart1".localized
        let privacyPolicyPart2 = "privacyPolicyPart2".localized
        let allText = String(format: "%@ %@", privacyPolicyPart1, privacyPolicyPart2)
        
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.kacstPen(ofSize: 14), .foregroundColor: UIColor.white.withAlphaComponent(0.64),.kern: 0.0])
        
        if let part2Range = allText.range(of: privacyPolicyPart2) {
            attributedString.addAttributes([.foregroundColor: UIColor.white], range: part2Range.nsRange(in: allText))
        }
        return attributedString
    }
    
    private func addAppleIDButton() {
        for view in appleIdButtonContainer.subviews {
            view.removeFromSuperview()
        }
        appleIdButtonHeightConstraint.constant = 0
        
//        guard data is LoginFormVM else {
//            return
//        }
        if #available(iOS 13.0, *) {
            appleIdButtonHeightConstraint.constant = 56
            appleIdButtonContainer.isHidden = false
            
            let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
            authorizationButton.translatesAutoresizingMaskIntoConstraints = false
            authorizationButton.addTarget(self, action:
                #selector(appleAuthorizationButtonTapped(_:)), for: .touchUpInside)
            
            appleIdButtonContainer.addSubview(authorizationButton)
            authorizationButton.leadingAnchor.constraint(equalTo: appleIdButtonContainer.leadingAnchor).isActive = true
            authorizationButton.widthAnchor.constraint(equalTo: appleIdButtonContainer.widthAnchor).isActive = true
            authorizationButton.topAnchor.constraint(equalTo: appleIdButtonContainer.topAnchor).isActive = true
            authorizationButton.heightAnchor.constraint(equalTo: appleIdButtonContainer.heightAnchor).isActive = true
            authorizationButton.cornerRadius = 18
        }
    }
    
    @objc func appleAuthorizationButtonTapped(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: UIButton) {
        delegate?.forgetPasswordTapped()
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: UIButton) {
        delegate?.privacyPolicyTapped()
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        delegate?.facebookButtonTapped()
    }
}

extension MembershipFormView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if let cellData = data.items[indexPath.row] as? MembershipFormTextFieldCellVM {
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: MembershipTextFieldCell.identifier) as! MembershipTextFieldCell
            textFieldCell.data = cellData
            textFieldCell.textFeild.tag = indexPath.row
            textFieldCell.delegate = self
            cell = textFieldCell
            
        } else if let cellData = data.items[indexPath.row] as? MembershipFormButtonCellVM {
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: MembershipButtonCell.identifier) as! MembershipButtonCell
            buttonCell.data = cellData
            cell = buttonCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if data.items[indexPath.row] is MembershipFormButtonCellVM {
            sumbitButtonTapped()
        }
    }
}

extension MembershipFormView: MembershipTextFieldCellDelegate {
    
    func triggerSubmitButton() {
         sumbitButtonTapped()
    }
}

extension MembershipFormView: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        guard let loginVM = data as? LoginFormVM else {
//            return
//        }
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential, let identityToken = appleIDCredential.identityToken {
            let token = String(decoding: identityToken, as: UTF8.self)
            let name = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
            let loginModel = AppleLoginModel(token: token, user_id: appleIDCredential.user, name: name, email: appleIDCredential.email)
            
            LoadingHud.shared.show(animated: true)
            
            data.appleLogin(data: loginModel) { [weak self] (error) in
                LoadingHud.shared.hide(animated: true)
                if let error = error {
                    self?.delegate?.showErrorMessageView(title: nil, message: error.message ?? "generalErrorMessage".localized)
                } else {
                    self?.delegate?.submitSucceeded()
                }
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorizationController error: \(error)")
        
    }
}
