//
//  HomeSections.swift
//  Tawazon
//
//  Created by Shadi on 14/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

struct HomeSectionsModel: Codable, ModelInitializable {
    let status: Bool
    let sections: [HomeSectionModel]
    let pages: [PremiumPage]?
}

enum HomeSectionStyle: String, Codable {
    case card
    case list
    case largeList
    case banner
    case verticalList
    case talkList
}

enum HomeBannerStyle: String, Codable  {
    case banner1
    case banner2
    case banner3
    case banner4
    case banner5
    case banner6
}

struct HomeSectionModel: Codable, ModelInitializable {
    let id, title: String
    let subtitle, icon, buttonLabel, moreLabel, image: String?
    let categoryId: String?
    let sessions: [SessionModel]
    let items: [ItemModel]
    let style: HomeSectionStyle?
    let type: Int
    let bannerType: HomeBannerStyle?
    let clickable: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, icon, image
        case categoryId = "category_id"
        case sessions
        case items
        case style
        case type
        case bannerType
        case buttonLabel = "button_label"
        case moreLabel = "more_label"
        case clickable
    }
}
