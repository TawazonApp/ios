//
//  ForgetPasswordFormVM.swift
//  NewLife
//
//  Created by Shadi on 12/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ForgetPasswordFormVM: ForgetPasswordVM {

    let emailTextField: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .email)
    
    let submitButton: MembershipFormButtonCellVM = MembershipFormButtonCellVM(title: "forgetPasswordSendButton".localized)
    
    override var title: String! {
        return "forgetPasswordTitle".localized
    }
    
    override var subTitle: String! {
        return "forgetPasswordSubTitle".localized
    }
    
    override var items: [Any] {
        return [emailTextField, submitButton]
    }
    
    
    override func submit(completion: @escaping (_ email: String?, _ error: CustomError?) -> Void) {
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.forgetPasswordScreenSubmit, payload: nil)
        if emailTextField.isValid() {
            
            let forgetModel = ForgetPasswordModel.init(email: emailTextField.value!)
            service.forgetPassword(data: forgetModel) { (error) in
                 completion(forgetModel.email, error)
            }
        } else {
            let error = CustomError(message: "forgetPasswordErrorMessage".localized, statusCode: nil)
            completion(emailTextField.value, error)
        }
    }
}
