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
    
    init(id: String, name: String, isSelected: Bool = false) {
        self.name = name
        self.id = id
        self.isSelected = isSelected
    }
}
