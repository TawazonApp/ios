//
//  MoodTrackerVM.swift
//  Tawazon
//
//  Created by mac on 31/01/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation

import UIKit

class MoodTrackerVM: NSObject {
    
    var service: TodayService!
    var MoodTrackerData: MoodTrackerModel?
    
    
    init(service: TodayService) {
        self.service = service
    }
    
    func getMoodTrackerData(from: String, completion: @escaping (CustomError?) -> Void) {
        service.getMoodTrackerData(from: from) { [weak self] (data, error) in
            self?.MoodTrackerData = data
            completion(error)
        }
    }
}
