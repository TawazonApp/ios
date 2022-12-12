//
//  BasePremiumModel.swift
//  Tawazon
//
//  Created by mac on 28/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
struct BasePremiumModel: Codable, ModelInitializable {
    let status: Bool
    let premiumPage: PremiumPage
    let plans: [Plan]

    enum CodingKeys: String, CodingKey {
        case status
        case premiumPage = "premium_page"
        case plans = "types"
    }
}

// MARK: - PremiumPage
struct PremiumPage: Codable {
    let id: String
    let image: String?
    let title, subtitle, content, continueLabel: String
    let featureItems: [FeatureItem]

    enum CodingKeys: String, CodingKey {
        case id, image, title, subtitle, content
        case continueLabel = "continue_label"
        case featureItems = "items"
    }
}

// MARK: - Item
struct FeatureItem: Codable {
    let id: String
    let image: String?
    let title, content: String
    let planComp: PlanComp?
}
struct PlanComp: Codable{
    let premium, free: Bool
}
// MARK: - TypeElement
struct Plan: Codable {
    let id, title: String
    let subtitle: String?
    let color: String?
    let enabled: Bool
    let discount: Float?
    let discountCampaign: DiscountCampaign?
    let priority: String?
}

// MARK: - DiscountCampaign
struct DiscountCampaign: Codable {
    let id, title, subtitle: String
    let image: String
    let isRamadan: Bool
}
