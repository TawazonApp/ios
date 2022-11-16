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
    var subFeelings: [SubFeelingItem]?
    
    init(id: String, name: String, subFeelings: [SubFeelingItem]?, isSelected: Bool = false) {
        self.name = name
        self.id = id
        self.subFeelings = subFeelings
        self.isSelected = isSelected
    }
}
