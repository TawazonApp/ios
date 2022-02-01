//
//  TrackingModel.swift
//  Tawazon
//
//  Created by mac on 01/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

struct TrackingModel: Codable, ModelInitializable {
    let name, campaignId: String
    let time: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case name
        case campaignId = "campaign_id"
        case time = "event_timestamp"
    }
}

