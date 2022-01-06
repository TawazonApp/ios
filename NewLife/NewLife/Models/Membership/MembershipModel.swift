//
//  MembershipModel.swift
//  NewLife
//
//  Created by Shadi on 11/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct MembershipModel: Codable, ModelInitializable {
    
    let token: String
    let userInfo: UserInfoModel
    let goals: [GoalModel]?
    
    enum CodingKeys: String, CodingKey {
        case token
        case userInfo = "user_info"
        case goals = "goals"
    }
}


