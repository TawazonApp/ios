//
//  ForgetPasswordViewController.swift
//  NewLife
//
//  Created by Shadi on 12/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: HandleErrorViewController {
    
    enum ViewType {
        case forgetPassword
        case resetPassword
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var formView: ForgetPasswordFormView!
    
    var viewType:ViewType = .forgetPassword
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initializeNotificationCenter()
        reloadFormView(email: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func initialize() {
        
        view.backgroundColor = UIColor.clear
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(#imageLiteral(resourceName: "BackArrow.pdf").flipIfNeeded, for: .normal)
    
        formView.topConstraint.constant = centerFormView()
        
        formView.delegate = self
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
    }
    
    private func initializeNotificationCenter() {
        NotificationCenter.default.addObserver(self,  selector: #selector(self.keyboardNotification(notification:)),  name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func centerFormView()-> CGFloat {
        return (self.view.frame.height - formView.frame.height)/2
    }
    
   
    private func reloadFormView(email: String?, animated: Bool = false) {
        
        let service = MembershipServiceFactory.service()
        formView.data = (viewType == .forgetPassword) ? ForgetPasswordFormVM(service: service) : ResetPasswordFormVM(service: service, email: email ?? "")
        
        if self.isEditing  == false {
            formView.topConstraint.constant = centerFormView()
        }
        
        if animated {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction.easeOutQuart
            formView.layer.add(transition, forKey: nil)
        }
    }
    
    private func dimiss() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dimiss()
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
            }, completion: nil)
    }
}

extension ForgetPasswordViewController: ForgetPasswordFormViewDelegate {
    
    func forgetPasswordSent(email: String) {
        viewType = .resetPassword
        reloadFormView(email: email, animated: true)
    }
    
    func showErrorMessageView(title: String?, message: String) {
        showErrorMessage(title: title, message: message)
    }
    
    func resetPasswordSucceeded() {
        dimiss()
    }
}


extension ForgetPasswordViewController {
    
    class func instantiate() -> ForgetPasswordViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: ForgetPasswordViewController.identifier) as! ForgetPasswordViewController
        return viewController
    }
}
