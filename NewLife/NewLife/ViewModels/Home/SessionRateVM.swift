//
//  SessionRateVM.swift
//  Tawazon
//
//  Created by Shadi on 27/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

class SessionRateVM {
    var service: SessionService!
    
    init(service: SessionService) {
        self.service = service
    }
    
    func rateSession(sessionId: String, rate: Int, completion: @escaping (CustomError?) -> Void){
        service.rateSession(sessionId: sessionId, rate: rate, completion: completion)
    }
}
