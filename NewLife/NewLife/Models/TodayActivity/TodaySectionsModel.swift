//
//  TodayActivity.swift
//  Tawazon
//
//  Created by mac on 21/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
struct TodaySectionsModel: Codable, ModelInitializable {
    let status: Bool
    let sections: [TodaySectionModel]
}
