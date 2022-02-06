//
//  SectionSessions.swift
//  Tawazon
//
//  Created by Shadi on 04/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

struct SectionSessions: Codable, ModelInitializable {
    let status: Bool
    let section: SectionModel
    let items: [SessionModel]
    enum CodingKeys: String, CodingKey {
        case status, items
        case section = "item"
    }
}

struct SectionModel: Codable, ModelInitializable {
    let id, name: String
//    let subtitle, icon: String?
//    let categoryId: String?
//    let style: HomeSectionStyle?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
//        case subtitle, icon
//        case categoryId = "category_id"
//        case style
    }
}

