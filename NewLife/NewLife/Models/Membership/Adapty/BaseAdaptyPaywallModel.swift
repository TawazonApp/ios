//
//  BaseAdaptyPaywallModel.swift
//  Tawazon
//
//  Created by mac on 14/03/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation

struct BaseAdaptyPaywallModel: Codable, ModelInitializable {
    let premiumPage: Paywall
    

    enum CodingKeys: String, CodingKey {
        case premiumPage = "page"
    }
}

// MARK: - PremiumPage
struct Paywall: Codable {
    let id: String
    let image: String?
    let title, subtitle, content, continueLabel: String
    let featureItems: [FeatureItem]
    let type: String?
    let showPopup: Bool?
    let featureTitle: String?
    let action: Action?
    let plans: [AdaptyPlan]
    
    enum CodingKeys: String, CodingKey {
        case id, image, title, subtitle, content
        case continueLabel = "continueLabel"
        case featureItems = "items"
        case type
        case showPopup
        case featureTitle
        case action
        case plans = "types"
    }
}

// MARK: - TypeElement
struct AdaptyPlan: Codable {
    let id, title: String
    let itemId: String
    let period: String
    let subtitle: String?
    let color: String?
    let enabled: Bool
    let discount: Float?
    let discountCampaign: DiscountCampaign?
    let priority: String?
    let price: Double
}
