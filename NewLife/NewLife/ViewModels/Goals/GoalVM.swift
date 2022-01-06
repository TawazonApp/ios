//
//  GoalCellVM.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class GoalVM: NSObject {
    
    var id: String!
    var name: String!
    var isSelected: Bool!
    
    init(id: String, name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
    
}
