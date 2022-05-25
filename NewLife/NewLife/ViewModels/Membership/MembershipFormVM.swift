//
//  MembershipFormVM.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MembershipFormVM: NSObject {
    
    let service: MembershipService!
    
    var title: String! {
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
    func appleLogin(data: AppleLoginModel, completion: @escaping ( _ error: CustomError?) -> Void) {
        service.appleLogin(data: data) { (membershipModel, error) in
            if let membershipModel = membershipModel {
                
                UserDefaults.saveUserToken(token: membershipModel.token)
                
                UserInfoManager.shared.setUserInfo(userInfo: membershipModel.userInfo)
                UserInfoManager.shared.setGoals(goals: GoalsModel.init(goals: membershipModel.goals))
                TrackerManager.shared.sendLoginEvent()
            }
            completion(error)
        }
    }
}
