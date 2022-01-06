//
//  LoginModel.swift
//  NewLife
//
//  Created by Shadi on 11/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct LoginModel: Codable, ModelInitializable {
    let email, password: String
}
