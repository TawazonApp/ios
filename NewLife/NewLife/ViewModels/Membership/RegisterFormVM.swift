//
//  RegisterFormVM.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class RegisterFormVM: MembershipFormVM {

    let nameTextField: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .name)
    
    let emailTextField: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .email)
    
    let passwordTextField: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .registerPassword)
    
    let submitButton: MembershipFormButtonCellVM = MembershipFormButtonCellVM(title: "registerSubmitButtonTitle".localized)
    
    override var title: String! {
        return "registerFormTitle".localized
    }
    
    override var items: [Any] {
        return [nameTextField, emailTextField, passwordTextField, submitButton]
    }
    
    override func submit(completion: @escaping (_ error: CustomError?) -> Void) {
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.registrationScreenSubmit, payload: nil)
        
        if nameTextField.isValid() && emailTextField.isValid() && passwordTextField.isValid() {
            let registerModel = RegisterModel.init(name: nameTextField.value!, email: emailTextField.value!, password: passwordTextField.value!, confirmPassword: passwordTextField.value!)
            
            service.register(data: registerModel) { (membershipModel, error) in
                
                if let membershipModel = membershipModel {
                    
                    UserDefaults.saveUserToken(token: membershipModel.token)
                    
                    UserInfoManager.shared.setUserInfo(userInfo: membershipModel.userInfo)
                  
                    UserInfoManager.shared.setGoals(goals:   GoalsModel.init(goals: membershipModel.goals))
                    TrackerManager.shared.sendCompleteRegistrationEvent(method: .email)
                }
                completion(error)
            }
        } else {
            let error = CustomError(message: "registerInValidErrorMessage".localized, statusCode: nil)
            completion(error)
        }
    }
}
