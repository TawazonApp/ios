//
//  SeriesModel.swift
//  Tawazon
//
//  Created by mac on 31/07/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
struct SeriesModel: Codable, ModelInitializable {
    let status: Bool
    let seriesDetails: SeriesDetailsModel
    let sessions: [SessionModel]
    
    enum CodingKeys: String, CodingKey{
        case status
        case sessions = "items"
        case seriesDetails = "item"
    }
}


struct SeriesDetailsModel: Codable, ModelInitializable {
    let id: String
    let title: String?
    let subtitle: String?
    let image: String?
    let thumbnail: String?
    let content: String?
    let footerTitle: String?
    let footerSubtitle: String?
    let numberOfSessions: Int
    var completedItemsCount: Int?
    var favorite: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case image
        case thumbnail
        case content
        case footerTitle = "footer_title"
        case footerSubtitle = "footer_subtitle"
        case numberOfSessions = "items_count"
        case completedItemsCount
        case favorite
    }
}
