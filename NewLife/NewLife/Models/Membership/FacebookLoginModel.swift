//
//  FacebookLoginModel.swift
//  NewLife
//
//  Created by Shadi on 15/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct FacebookLoginModel: Codable, ModelInitializable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "token"
    }
}
