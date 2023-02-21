//
//  MoodTrackerStatsVM.swift
//  Tawazon
//
//  Created by mac on 19/02/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation
import UIKit

class MoodTrackerStatsVM: NSObject {
    
    var service: TodayService!
    var MoodTrackerStatsData: MoodTrackerStatsModel?
    
    
    init(service: TodayService) {
        self.service = service
    }
    
    func getMoodTrackerStatsData(completion: @escaping (CustomError?) -> Void) {
        service.getMoodTrackerStatsData() { [weak self] (data, error) in
            self?.MoodTrackerStatsData = data
            completion(error)
        }
    }
}
