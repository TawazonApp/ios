//
//  SubCategorySectionModel.swift
//  Tawazon
//
//  Created by mac on 24/01/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

struct SubCategorySectionModel: Codable, ModelInitializable {
    let item: Item!
    var sessions: [SessionModel]?
    
    enum CodingKeys: String, CodingKey {
        case item
        case sessions = "items"
    }
}

struct Item: Codable{
    let id: String!
    let name: String!
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
    }
}
