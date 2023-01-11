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
    var intensity: Intensity?
    var icon: String?
    
    init(id: String, name: String, priority: Int, subFeelings: [SubFeelingItem]?, isSelected: Bool = false, intensity: Intensity?, icon: String?) {
        self.name = name
        self.id = id
        self.priority = priority
        self.subFeelings = subFeelings
        self.isSelected = isSelected
        self.intensity = intensity
        self.icon = icon
    }
}
