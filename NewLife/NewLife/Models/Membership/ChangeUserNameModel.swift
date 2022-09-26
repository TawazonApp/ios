//
//  ChangeUserNameModel.swift
//  NewLife
//
//  Created by Shadi on 17/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct ChangeUserNameModel: Codable, ModelInitializable {
    let name: String?
    let displayName: String?
    
    enum CodingKeys: String, CodingKey {
        case name, displayName
    }
}
