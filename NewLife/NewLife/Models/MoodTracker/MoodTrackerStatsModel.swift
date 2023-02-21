//
//  MoodTrackerStatsModel.swift
//  Tawazon
//
//  Created by mac on 19/02/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation
struct MoodTrackerStatsModel: Codable, ModelInitializable{
    let completedSessions, tawazonMinutes: Int?
    let activeDays, consecutivePresence: Int?
}

