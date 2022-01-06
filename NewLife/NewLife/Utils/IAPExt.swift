//
//  IAPExt.swift
//  NewLife
//
//  Created by Shadi on 30/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation
import StoreKit

@available(iOS 11.2, *)
extension SKProduct.PeriodUnit {
    
    func description(numberOfUnits: Int? = nil) -> String? {
        if numberOfUnits == nil {
            return nil
        }
        
        let period:String = {
            switch self {
            case .day: return "purchaseTrialDay".localized
            case .week: return "purchaseTrialWeek".localized
            case .month: return "purchaseTrialMonth".localized
            case .year: return "purchaseTrialYear".localized
            }
        }()
        if self == .week && numberOfUnits == 1 {
            return "\(numberOfUnits! * 7) \("purchaseTrialDay".localized)"
        }
        return "\(numberOfUnits!) \(period)"
    }
}
