//
//  LoginViewController.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AudioToolbox
import SwiftyStoreKit
class MembershipViewController: HandleErrorViewController {
    
    enum ViewType {
        case login
        case register
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var formView: MembershipFormView!
    
    let loadAnimationDuration: TimeInterval = 0.5
    var didAppeared = false
    var viewType: ViewType! = .login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initializeNotificationCenter()
        reloadFormView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if didAppeared == false {
            animateWhenDidLoad()
            self.formView.topConstraint.constant = centerFormView()
            didAppeared = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func initialize() {
        
        view.backgroundColor = UIColor.clear
        
        logoImageView.image = UIImage(named: "LogoWithName")
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "Cancel.pdf"), for: .normal)
        
        switchButton.tintColor = UIColor.white
        switchButton.setAttributedTitle(switchButtonAttributeText(), for: .normal)
        
        blurView.effect = nil
        view.alpha = 0.0
        formView.topConstraint.constant = centerFormView()
        formView.delegate = self
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
    }
    
    private func facebookLogin() {
        
        let facebook = FacebookLoginVM(service: MembershipServiceFactory.service())
        
        facebook.login(fbManager: LoginManager(), viewController: self) { [weak self] (accessToken, error) in
            
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                return
            }
            
            guard let accessToken = accessToken else { return }
            
            LoadingHud.shared.show(animated: true)
            facebook.submit(accessToken: accessToken, completion: { [weak self] (submitError) in
                if let error = error {
                    LoadingHud.shared.hide(animated: true)
                    self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                    return
                }
                self?.userLoggedAction()
                LoadingHud.shared.hide(animated: true)
            })
            
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func centerFormView()-> CGFloat {
        return (self.view.frame.height - formView.frame.height)/2
    }
    
    private func animateWhenDidLoad() {
        
        UIView.animate(withDuration: loadAnimationDuration) { [weak self] in
            self?.blurView.effect = UIBlurEffect(style: .dark)
            self?.view.alpha = 1.0
        }
    }
    
    private func reloadFormView() {
        let service = MembershipServiceFactory.service()
        formView.data = (viewType == .login) ? LoginFormVM(service: service) : RegisterFormVM(service: service)
    }
    
    private func switchViewType () {
        viewType = (viewType == .login) ? .register : .login
        switchButton.setAttributedTitle(switchButtonAttributeText(), for: .normal)
        reloadFormView()
    }
    
    private func dimiss() {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: loadAnimationDuration, animations: { [weak self] in
            self?.blurView.effect = UIBlurEffect(style: .dark)
            self?.view.alpha = 0.0
        }) { [weak self] (finish) in
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        SystemSoundID.play(sound: .Sound2)
        dimiss()
    }
    
    @IBAction func switchButtonTapped(_ sender: UIButton) {
        switchViewType()
    }
    
    private func userLoggedAction() {
        if let appDelegate =  UIApplication.shared.delegate as? AppDelegate {
            appDelegate.sendFcmToken()
            openCorrectViewController()
        }
    }
    
    private func openGoalsViewController() {
        self.view.endEditing(true)
        let viewController = GoalsViewController.instantiate(sourceView: .membership)
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
    
    private func openMainViewController() {
        SystemSoundID.play(sound: .LaunchToHome)
        self.view.endEditing(true)
        (UIApplication.shared.delegate as? AppDelegate)?.pushWindowToRootViewController(viewController: MainTabBarController.instantiate(), animated: true)
    }
    
    private func openPrivacyViewController()  {
        self.view.endEditing(true)
        let viewController = PrivacyViewController.instantiate(viewType: .termsAndConditions)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func openForgetPasswordViewController()  {
        self.view.endEditing(true)
        let viewController = ForgetPasswordViewController.instantiate()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func openCorrectViewController() {
        
        if UserDefaults.isUserSelectGoals() == false {
            openGoalsViewController()
        } else {
            openMainViewController()
        }
    }
    
    private func switchButtonAttributeText() -> NSMutableAttributedString {
        
        let part1 = (viewType == .login) ? "hasNotAccount".localized : "hasAccount".localized
        let part2 = (viewType == .login) ? "goToRegister".localized : "goToLogin".localized
        let allText = String(format: "%@ %@", part1, part2)
        
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.kacstPen(ofSize: 16), .foregroundColor: UIColor.white.withAlphaComponent(0.64),.kern: 0.0])
        
        if let part2Range = allText.range(of: part2) {
            attributedString.addAttributes([.foregroundColor: UIColor.white], range: part2Range.nsRange(in: allText))
        }
        return attributedString
    }
    
    private func initializeNotificationCenter() {
        NotificationCenter.default.addObserver(self,  selector: #selector(self.keyboardNotification(notification:)),  name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY:CGFloat = endFrame?.origin.y ?? 0
        
        
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let screenHeight = UIScreen.main.bounds.height
        var formTopConstant = screenHeight - ((screenHeight - endFrameY) + formView.frame.height) - 16
        
        var keyboardDismissed = false
        if endFrameY >= screenHeight {
           formTopConstant = centerFormView()
            keyboardDismissed = true
        }
        
        if formTopConstant <= 40 {
            formTopConstant = 40
        }
        
        animateViewsWithKeyboardChanges(formTopConstant: formTopConstant, duration: duration, animationOption: animationCurve, keyboardDismissed: keyboardDismissed)
    }
    
    private func animateViewsWithKeyboardChanges (formTopConstant: CGFloat, duration: TimeInterval, animationOption: UIView.AnimationOptions, keyboardDismissed: Bool) {
        
        formView.topConstraint.constant = formTopConstant
        
        UIView.animate(withDuration: duration, delay: 0, options: animationOption,animations: { [weak self] in
            self?.view.layoutIfNeeded()
            let alpha: CGFloat = keyboardDismissed ? 1.0 : 0.0
            self?.logoImageView.alpha = alpha
            }, completion: nil)
    }
    
}

extension MembershipViewController: MembershipFormViewDelegate {
    
    func submitSucceeded() {
        userLoggedAction()
    }
    
    func facebookButtonTapped() {
        facebookLogin()
    }
    
    func showErrorMessageView(title: String?, message: String) {
        showErrorMessage(title: title, message: message)
    }
    
    func forgetPasswordTapped() {
        openForgetPasswordViewController()
    }
    
    func privacyPolicyTapped() {
        openPrivacyViewController()
    }
}

extension MembershipViewController {
    
    class func instantiate(viewType: ViewType) -> MembershipViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: MembershipViewController.identifier) as! MembershipViewController
        viewController.viewType = viewType
        return viewController
    }
}
