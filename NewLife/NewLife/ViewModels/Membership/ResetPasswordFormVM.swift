//
//  ResetPasswordFormVM.swift
//  NewLife
//
//  Created by Shadi on 12/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ResetPasswordFormVM: ForgetPasswordVM {

    let emailTextField: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .email, isEnabled: false)
    
    let verificationCodeTextField: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .verificationCode)
    
    let passwordTextField: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .newPassword)
    
    let submitButton: MembershipFormButtonCellVM = MembershipFormButtonCellVM(title: "resetPasswordButton".localized)
    
    override var title: String! {
        return "resetPasswordTitle".localized
    }
    
    override var subTitle: String! {
        return "resetPasswordSubTitle".localized
    }
    
    override var items: [Any] {
        return [emailTextField, verificationCodeTextField, passwordTextField, submitButton]
    }
    
    init(service: MembershipService, email: String) {
        super.init(service: service)
        emailTextField.value = email
    }
    
    override func submit(completion: @escaping (_ email: String?, _ error: CustomError?) -> Void) {
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.resetPasswordScreenSubmit, payload: nil)
        if emailTextField.isValid() && verificationCodeTextField.isValid() && passwordTextField.isValid() {
            
            let forgetModel = ResetPasswordModel.init(email: emailTextField.value!, password: passwordTextField.value!, confirmPassword: passwordTextField.value!, passwordToken: verificationCodeTextField.value!)
            
            service.resetPassword(data: forgetModel) { (error) in
                completion(forgetModel.email, error)
            }
        } else {
            let error = CustomError(message: "resetPasswordErrorMessage".localized, statusCode: nil)
            completion(emailTextField.value, error)
        }
    }
}
