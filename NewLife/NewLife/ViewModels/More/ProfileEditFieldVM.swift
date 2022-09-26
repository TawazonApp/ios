//
//  ProfileEditFieldVM.swift
//  NewLife
//
//  Created by Shadi on 17/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ProfileFieldFormVM: NSObject {
    
    let service: MembershipService!
    
    var title: String! {
        return ""
    }
    
    var subTitle: String! {
        return ""
    }
    
    var items: [Any] {
        return []
    }
    
    init(service: MembershipService) {
        self.service = service
    }
    
    func submit(completion: @escaping (_ error: CustomError?) -> Void) {
        
    }
}

class ProfileEditUserNameFormVM: ProfileFieldFormVM {
    
    let userName: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .name)
    
    let submitButton: MembershipFormButtonCellVM = MembershipFormButtonCellVM(title: "saveButtonTitle".localized)
    
    override var title: String! {
        return "profileEditUserNameTitle".localized
    }
    
    override var subTitle: String! {
        return ""
    }
    
    override var items: [Any] {
        return [userName, submitButton]
    }
    
    init(service: MembershipService, name: String?) {
        super.init(service: service)
        userName.value = name
    }
    
    override func submit(completion: @escaping (_ error: CustomError?) -> Void) {
        
        if userName.isValid() {
            let userNameModel = ChangeUserNameModel.init(name: userName.value!, displayName: nil)
            
            service.changeUserName(data: userNameModel) { (userInfo, error) in
                if let userInfo = userInfo {
                    UserInfoManager.shared.setUserInfo(userInfo: userInfo)
                }
                completion(error)
            }
        } else {
            let error = CustomError(message: "profileEditUserNameErrorMessage".localized, statusCode: nil)
            completion(error)
        }
    }
}

class ProfileEditUserDisplayNameFormVM: ProfileFieldFormVM {
    
    let userDisplsyName: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .displayName)
    
    let submitButton: MembershipFormButtonCellVM = MembershipFormButtonCellVM(title: "saveButtonTitle".localized)
    
    override var title: String! {
        return "profileEditDisplayNameTitle".localized
    }
    
    override var subTitle: String! {
        return ""
    }
    
    override var items: [Any] {
        return [userDisplsyName, submitButton]
    }
    
    init(service: MembershipService, name: String?) {
        super.init(service: service)
        userDisplsyName.value = name
    }
    
    override func submit(completion: @escaping (_ error: CustomError?) -> Void) {
        
        if userDisplsyName.isValid() {
            let userNameModel = ChangeUserNameModel.init(name: nil, displayName: userDisplsyName.value!)
            
            service.changeUserName(data: userNameModel) { (userInfo, error) in
                if let userInfo = userInfo {
                    UserInfoManager.shared.setUserInfo(userInfo: userInfo)
                }
                completion(error)
            }
        } else {
            let error = CustomError(message: "profileEditUserNameErrorMessage".localized, statusCode: nil)
            completion(error)
        }
    }
}

class ProfileChangePasswordFormVM: ProfileFieldFormVM {
    
    let oldPassword: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .oldPassword)
    
    let newPassword: MembershipFormTextFieldCellVM = MembershipFormTextFieldCellVM(type: .newPassword)
    
    let submitButton: MembershipFormButtonCellVM = MembershipFormButtonCellVM(title: "saveButtonTitle".localized)
    
    override var title: String! {
        return "profileChangePasswordTitle".localized
    }
    
    override var subTitle: String! {
        return ""
    }
    
    override var items: [Any] {
        return [oldPassword, newPassword, submitButton]
    }
    
    override func submit(completion: @escaping (_ error: CustomError?) -> Void) {
        
        if oldPassword.isValid() && newPassword.isValid() {
            
            let passwordModel = ChangePasswordModel.init(oldPassword: oldPassword.value!, newPassword: newPassword.value!, confirmPassword: newPassword.value!)
            service.changePassword(data: passwordModel) { (error) in
                completion(error)
            }
        } else {
            let error = CustomError(message: "profileChangePasswordErrorMessage".localized, statusCode: nil)
            completion(error)
        }
    }
}
