//
//  SubscriptionTypes.swift
//  Tawazon
//
//  Created by Shadi on 18/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

struct SubscriptionTypes: Codable, ModelInitializable {
    let status: Bool
    let items: [SubscriptionTypeItem]
}

struct SubscriptionTypeItem: Codable {
    let id: String
    let title: String?
    let discount: Float?
    let discountCampaign: SubscriptionTypeCampaign?
}

struct SubscriptionTypeCampaign: Codable {
    let id: String
    let title, subtitle, image: String?
    let isRamadan: Bool?
    let discountDescription: String?
}
