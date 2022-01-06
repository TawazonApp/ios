//
//  FeelingsSessions.swift
//  Tawazon
//
//  Created by Shadi on 04/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

struct FeelingsSessions: Codable, ModelInitializable {
    let status: Bool
    let feelings: [FeelingItem]?
    let items: [SessionModel]
}
