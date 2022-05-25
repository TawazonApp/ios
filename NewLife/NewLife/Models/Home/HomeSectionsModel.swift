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
}

enum HomeSectionStyle: String, Codable {
    case card
    case list
    case largeList
    case banner
    case verticalList
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
    let subtitle, icon: String?
    let categoryId: String?
    let sessions: [SessionModel]
    let style: HomeSectionStyle?
    let bannerType: HomeBannerStyle?
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, icon
        case categoryId = "category_id"
        case sessions
        case style
        case bannerType
    }
}
