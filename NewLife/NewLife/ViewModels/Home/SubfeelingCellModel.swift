//
//  subfeelingCellModel.swift
//  Tawazon
//
//  Created by mac on 13/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SubfeelingCellModel {

    let name: String
    let id: String
    var isSelected = false
    var priority: Int
    
    init(id: String, name: String, isSelected: Bool = false, priority: Int) {
        self.name = name
        self.id = id
        self.isSelected = isSelected
        self.priority = priority
    }
}
