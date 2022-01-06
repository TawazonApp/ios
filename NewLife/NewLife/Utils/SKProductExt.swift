//
//  SKProductExt.swift
//  Tawazon
//
//  Created by Shadi on 05/11/2021.
//  Copyright © 2021 Inceptiontech. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    var isTrial: Bool {
        var trial = false
        if #available(iOS 11.2, *) {
            if let introductoryPrice = self.introductoryPrice, introductoryPrice.paymentMode == SKProductDiscount.PaymentMode.freeTrial {
                trial = true
            }
        }
        return trial
    }
}
