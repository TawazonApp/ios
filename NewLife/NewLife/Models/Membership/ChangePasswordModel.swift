//
//  ChangePasswordModel.swift
//  NewLife
//
//  Created by Shadi on 17/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct ChangePasswordModel: Codable, ModelInitializable {
    let oldPassword: String
    let newPassword: String
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case newPassword = "password"
        case confirmPassword = "confirm_password"
    }
}
