//
//  GoalsModel.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct GoalsModel: Codable, ModelInitializable {
    
    let goals:[GoalModel]?

    enum CodingKeys: String, CodingKey {
        case goals = "goals"
    }
    
    func selectedGoals() -> [GoalModel] {
        return goals?.filter({$0.isSelected() == true}) ?? []
    }
}
