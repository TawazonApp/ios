//
//  SuperCategoryModel.swift
//  Tawazon
//
//  Created by mac on 21/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation

struct SuperCategoryModel: Codable, ModelInitializable{
//    let status: Bool
    let sections: [HomeSectionModel]
    let subCategories: [SubCategoryModel]
    var sessions: [SessionModel]?
    let pagination: pagination
    enum CodingKeys: String, CodingKey{
        case subCategories = "sub_categories"
        case sections, sessions, pagination
    }
}

struct pagination: Codable, ModelInitializable{
    let currentPage, nextPage, lastPage, totalPages: Int
        let totalItems: Int
        let hasMore: Bool

        enum CodingKeys: String, CodingKey {
            case currentPage = "current_page"
            case nextPage = "next_page"
            case lastPage = "last_page"
            case totalPages = "total_pages"
            case totalItems = "total_items"
            case hasMore = "has_more"
        }
}

