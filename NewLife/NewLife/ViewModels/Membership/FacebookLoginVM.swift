//
//  FacebookLoginVM.swift
//  NewLife
//
//  Created by Shadi on 15/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FacebookLoginVM: NSObject {
    
    let service: MembershipService!
    
    init(service: MembershipService) {
        self.service = service
    }
    
    func login(fbManager: LoginManager,viewController: UIViewController, completion: @escaping (_ accessToken: String?, _ error: CustomError?) -> Void) {
        
       // fbManager.loginBehavior = LoginBehavior
        fbManager.logOut()
        fbManager.logIn(permissions: ["public_profile", "email"], from: viewController) { (result, error) in
           
            var customError: CustomError?
            var accessToken: String?
            
            if let error = error {
                let nsError = error as NSError
                customError = CustomError(message: nsError.localizedFailureReason ?? nsError.localizedDescription, statusCode: nsError.code)
            } else if result != nil && result!.isCancelled == false {
                accessToken = AccessToken.current?.tokenString
            }
            completion(accessToken, customError)
        }
    }
    
    func submit(accessToken: String,  completion: @escaping (_ error: CustomError?) -> Void) {
        
        let facebookModel = FacebookLoginModel.init(accessToken: accessToken)
        
        service.facebookLogin(data: facebookModel) { (membershipModel, error) in
            if let membershipModel = membershipModel {
                
                UserDefaults.saveUserToken(token: membershipModel.token)
                
                UserInfoManager.shared.setUserInfo(userInfo: membershipModel.userInfo)
                UserInfoManager.shared.setGoals(goals: GoalsModel.init(goals: membershipModel.goals))
                
                TrackerManager.shared.sendCompleteRegistrationEvent(method: .facebook)

            }
            completion(error)
        }
    }
}
