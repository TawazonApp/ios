//
//  ResetPasswordModel.swift
//  NewLife
//
//  Created by Shadi on 12/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct ResetPasswordModel: Codable, ModelInitializable {
    let email, password, confirmPassword, passwordToken: String

    enum CodingKeys: String, CodingKey {
        case email
        case password
        case confirmPassword = "confirm_password"
        case passwordToken = "password_token"
    }
}
