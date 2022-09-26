//
//  MembershipFormTextFieldCellVM.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MembershipFormTextFieldCellVM: NSObject {
    
    enum types {
        case email
        case password
        case newPassword
        case oldPassword
        case registerPassword
        case name
        case displayName
        case verificationCode
    }
    
    enum Status {
        case none
        case error
        case active
        case valid
    }
    
    typealias DefaultValues = (iconName: String, placeholder: String, regularExpression: String, keyboardType: UIKeyboardType, isSecure: Bool)
    
    let type: types!
    var iconName: String!
    var placeholder: String!
    var regularExpression: String?
    var keyboardType: UIKeyboardType!
    var isSecure: Bool!
    var value: String?
    var validationStatus: Status = .none
    let isEnabled: Bool!
    var textContentType: UITextContentType?
    
    func isValid() -> Bool {
        let valid =  (regularExpression != nil) ? (value?.isValid(regularExpression: regularExpression!) ?? false) : true
        return valid
    }
    
    init(type: types, isEnabled: Bool = true) {
        self.type = type
        self.isEnabled = isEnabled
        super.init()
        
        let defaultValues = self.defaultValues(type: type)
        iconName = defaultValues.iconName
        placeholder = defaultValues.placeholder
        regularExpression = defaultValues.regularExpression
        keyboardType = defaultValues.keyboardType
        isSecure = defaultValues.isSecure
    }
    
    private func defaultValues(type: types) -> DefaultValues {
        var values: DefaultValues
        
        switch type {
        case .email:
            values.iconName = "Email"
            values.keyboardType = .emailAddress
            values.placeholder = "emailTextPlaceholder".localized
            values.regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            values.isSecure = false
            textContentType = .emailAddress
            break
        case .password:
            values.iconName = "Password"
            values.keyboardType = .default
            values.placeholder = "passwordTextPlaceholder".localized
            values.regularExpression = ".{8,}"
            values.isSecure = true
            if #available(iOS 11.0, *) {
                textContentType = .password
            }

            break
        case .newPassword:
            values.iconName = "Password"
            values.keyboardType = .default
            values.placeholder = "newPasswordTextPlaceholder".localized
            values.regularExpression = ".{8,}"
            values.isSecure = true
            if #available(iOS 11.0, *) {
                textContentType = .password
            }
            break
        case .oldPassword:
            values.iconName = "Password"
            values.keyboardType = .default
            values.placeholder = "oldPasswordTextPlaceholder".localized
            values.regularExpression = ".{8,}"
            values.isSecure = true
            if #available(iOS 11.0, *) {
                textContentType = .password
            }
            break
        case .registerPassword:
            values.iconName = "Password"
            values.keyboardType = .default
            values.placeholder = "registerPasswordTextPlaceholder".localized
            values.regularExpression = ".{8,}"
            values.isSecure = true
            if #available(iOS 11.0, *) {
                textContentType = .password
            }
            break
        case .name:
            values.iconName = "Name"
            values.keyboardType = .default
            values.placeholder = "nameTextPlaceholder".localized
            values.regularExpression = ".{2,}"
            values.isSecure = false
             textContentType = .name
            break
        case .displayName:
            values.iconName = "Name"
            values.keyboardType = .default
            values.placeholder = "displayNameTextPlaceholder".localized
            values.regularExpression = ".{2,}"
            values.isSecure = false
             textContentType = .name
            break
        case .verificationCode:
            values.iconName = "VerificationCode"
            values.keyboardType = .default
            values.placeholder = "verificationCodePlaceholder".localized
            values.regularExpression = ".{4,}"
            values.isSecure = false
            break
        }
        
        return values
    }
}
