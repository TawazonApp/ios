//
//  LoginFormVM.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class LoginFormVM: MembershipFormVM {
    
    let emailTextField: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .email)
    
    let passwordTextField: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .password)
    
     let submitButton: MembershipFormButtonCellVM = MembershipFormButtonCellVM(title: "loginSubmitButtonTitle".localized)
    
    override var title: String! {
        return "loginFormTitle".localized 
    }
    
    override var items: [Any] {
        return [emailTextField, passwordTextField, submitButton]
    }
    
    
    override func submit(completion: @escaping (_ error: CustomError?) -> Void) {
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.loginScreenSubmit, payload: nil)
        
        if emailTextField.isValid() && passwordTextField.isValid() {
            let loginModel = LoginModel.init(email: emailTextField.value!, password: passwordTextField.value!)
            
            service.login(data: loginModel) { (membershipModel, error) in
                if let membershipModel = membershipModel {
                    
                    UserDefaults.saveUserToken(token: membershipModel.token)
                    
                    UserInfoManager.shared.setUserInfo(userInfo: membershipModel.userInfo)
                    UserInfoManager.shared.setGoals(goals: GoalsModel.init(goals: membershipModel.goals))
                    TrackerManager.shared.sendLoginEvent()
                }
                completion(error)
            }
        } else {
            let error = CustomError(message: "loginInValidErrorMessage".localized, statusCode: nil)
            completion(error)
        }
    }
    
}
