//
//  TrackingModel.swift
//  Tawazon
//
//  Created by mac on 01/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

struct CampaignTrackingModel: Codable, ModelInitializable {
    let status: Bool
    let item: CampaignModel
    
    enum CodingKeys: String, CodingKey {
        case status, item
    }
}

struct CampaignModel: Codable, ModelInitializable{
    let originalCampaignId, currentCampaignId: String
    
    enum CodingKeys: String, CodingKey {
        case originalCampaignId = "original_campaign_id"
        case currentCampaignId = "campaign_id"
    }
}
