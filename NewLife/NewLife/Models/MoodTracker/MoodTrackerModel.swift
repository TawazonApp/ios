//
//  MoodTrackerModel.swift
//  Tawazon
//
//  Created by mac on 31/01/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation
struct MoodTrackerModel: Codable, ModelInitializable{
    let title: String?
    let chart: [ChartData]?
    let ranges: [RangeModel]?
}


struct ChartData: Codable, ModelInitializable{
    let dateValue: String?
    let feeling: FeelingItem?
    let intensity, cumulativeIntensity: Double?
    let date: ChartFeelingDateModel?
}

struct ChartFeelingDateModel: Codable, ModelInitializable{
    let value: String?
    let day: FeelingDayModel?
}

struct FeelingDayModel: Codable, ModelInitializable{
    let title: String?
    let value: Int?
}

struct RangeModel: Codable, ModelInitializable{
    let id : Int
    let title, from, view: String?
}
