//
//  WelecomeVM.swift
//  Tawazon
//
//  Created by Shadi on 26/06/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

class WelecomeVM {
    let service: MembershipService!
    
    init(service: MembershipService) {
        self.service = service
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
