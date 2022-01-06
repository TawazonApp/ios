//
//  FCMModel.swift
//  NewLife
//
//  Created by Shadi on 18/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct FCMModel: Codable, ModelInitializable {
    let fcmToken: String
    
    enum CodingKeys: String, CodingKey {
        case fcmToken = "token"
    }
}
