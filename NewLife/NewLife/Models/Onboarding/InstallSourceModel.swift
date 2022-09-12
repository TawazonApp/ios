//
//  InstallSourceModel.swift
//  Tawazon
//
//  Created by mac on 08/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
struct InstallSourceModel: Codable, ModelInitializable {
    
    let id: String!
    let name: String!
    var selected: Bool!
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case selected
    }
    
}
