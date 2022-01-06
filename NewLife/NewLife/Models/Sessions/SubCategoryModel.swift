//
//  SubCategryModel.swift
//  NewLife
//
//  Created by Shadi on 14/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct SubCategoryModel: Codable, ModelInitializable {
    let id: String!
    let name: String!
    var sessions: [SessionModel]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case sessions
    }
}
