//
//  GoalModel.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct GoalModel: Codable, ModelInitializable {
    
    let id: String!
    let name: String!
    var selected: Int!
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case selected = "selected"
    }
    
    mutating func setSelected(isSelected: Bool) {
        self.selected = isSelected.intValue()
    }
    
    func isSelected() -> Bool {
        return selected!.boolValue()
    }
}
