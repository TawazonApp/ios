//
//  FeelingsListModel.swift
//  Tawazon
//
//  Created by Shadi on 04/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation
struct FeelingsListModel: Codable, ModelInitializable {
    let status: Bool
    let items: [FeelingItem]
}

struct FeelingItem: Codable {
    let id, title: String
    let selected: Int?
    let subFeelings: [SubFeelingItem]?
    let priority: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case selected
        case priority
        case subFeelings = "items"
    }
}
struct SubFeelingItem: Codable{
    let id, title: String
    var selected: Int?
    let priority: Int
}
