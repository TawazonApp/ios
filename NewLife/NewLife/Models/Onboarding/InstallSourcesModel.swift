//
//  InstallSourcesModel.swift
//  Tawazon
//
//  Created by mac on 08/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation

struct InstallSourcesModel: Codable, ModelInitializable {
    
    let installSources:[InstallSourceModel]?

    enum CodingKeys: String, CodingKey {
        case installSources = "items"
    }
    
    func selectedGoals() -> [InstallSourceModel] {
        return installSources?.filter({$0.selected == true}) ?? []
    }
}
