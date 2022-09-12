//
//  InstallSourceVM.swift
//  Tawazon
//
//  Created by mac on 08/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation

class InstallSourceVM: NSObject {
    
    var id: String!
    var name: String!
    var isSelected: Bool!
    
    init(id: String, name: String, isSelected: Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}


