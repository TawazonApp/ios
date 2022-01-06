//
//  RegisterModel.swift
//  NewLife
//
//  Created by Shadi on 11/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct RegisterModel: Codable, ModelInitializable {
    let name, email, password, confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case name, email, password
        case confirmPassword = "confirm_password"
    }
}
