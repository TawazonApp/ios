//
//  TodaySectionModel.swift
//  Tawazon
//
//  Created by mac on 21/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
struct TodaySectionModel: Codable, ModelInitializable {
    let id, title, title_2, content: String
    let subtitle, icon, buttonLabel, moreLabel, image: String?
    let categoryId: String?
    let sessions: [SessionModel]
    let style: TodaySectionStyle
    let bannerType: HomeBannerStyle?
    let clickable: Bool?
    let items: [ItemModel]
    let completed: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, title_2, subtitle, content, icon, image
        case categoryId = "category_id"
        case sessions
        case style
        case bannerType
        case buttonLabel = "button_label"
        case moreLabel = "more_label"
        case clickable
        case items
        case completed
    }
}
enum TodaySectionStyle: String, Codable {
    case prepSession
    case feelingSelection
    case userFeelingSessions
    case singleQuote
    case tawazonTalk
}

struct ItemModel: Codable, ModelInitializable{
    let id: String
    let title, image, content, authorName: String?
}
