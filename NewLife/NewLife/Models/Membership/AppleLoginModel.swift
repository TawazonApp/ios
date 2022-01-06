//
//  AppleLoginModel.swift
//  Tawazon
//
//  Created by Shadi on 26/06/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

struct AppleLoginModel: Codable, ModelInitializable  {
    var token: String
    var user_id: String
    var name: String?
    var email: String?
}
