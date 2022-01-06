//
//  NotificationStatusModel.swift
//  NewLife
//
//  Created by Shadi on 18/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct NotificationStatusModel: Codable, ModelInitializable {
    var status: Int
    
    enum CodingKeys: String, CodingKey {
        case status = "notification_status"
    }
}
