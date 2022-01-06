//
//  StoreExt.swift
//  Tawazon
//
//  Created by Shadi on 31/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import StoreKit

class Rate {
    private static let minDays = 2
    private static let timesBeforePrompts = 3
    private static let requestReviewDateKey = "requestReviewDateKey"
    private static var numberOfTimesBeforePrompts = 0
    
    static func rateApp() {
        numberOfTimesBeforePrompts += 1
        if numberOfTimesBeforePrompts <= timesBeforePrompts {
            return
        }
        if let requestReviewDate = getRequestReviewDate(), requestReviewDate.timeIntervalSince(Date()) <= TimeInterval(minDays * 24 * 60 * 60) {
            return
        }
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            setRequestReview(date: Date())
        }
    }
    
    
    private static func setRequestReview(date: Date) {
        UserDefaults.standard.setValue(date, forKey: requestReviewDateKey)
        UserDefaults.standard.synchronize()
    }
    
    private static func getRequestReviewDate() -> Date? {
        return UserDefaults.standard.value(forKey: requestReviewDateKey) as? Date
    }
}

