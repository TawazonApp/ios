//
//  SearchCategoryModel.swift
//  Tawazon
//
//  Created by mac on 27/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
struct SearchCategoryModel: Codable, ModelInitializable {
    let id: String!
    let name: String!
    var sessions: [SessionModel]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case sessions
    }
}
