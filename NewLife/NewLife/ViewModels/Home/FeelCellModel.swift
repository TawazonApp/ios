//
//  FeelCellModel.swift
//  Tawazon
//
//  Created by Shadi on 15/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

class FeelCellModel {
    let name: String
    let id: String
    var isSelected = false
    let priority: Int
    var subFeelings: [SubFeelingItem]?
    
    init(id: String, name: String, priority: Int, subFeelings: [SubFeelingItem]?, isSelected: Bool = false) {
        self.name = name
        self.id = id
        self.priority = priority
        self.subFeelings = subFeelings
        self.isSelected = isSelected
    }
}
