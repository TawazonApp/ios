//
//  FCMVM.swift
//  NewLife
//
//  Created by Shadi on 18/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class FCMVM: NSObject {
    let service: MembershipService!
    
    init(service: MembershipService) {
        self.service = service
    }
    
    func sendFcmToken(fcmToken: String) {
        let data = FCMModel.init(fcmToken: fcmToken)
        service.sendFcm(data: data) { (error) in }
    }
}
