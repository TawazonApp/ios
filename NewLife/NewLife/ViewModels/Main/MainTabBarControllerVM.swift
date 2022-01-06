//
//  MainTabBarControllerVM.swift
//  Tawazon
//
//  Created by Shadi on 30/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

class MainTabBarControllerVM {
    private let service: SessionService!
    
    init(service: SessionService) {
        self.service = service
    }
    
    
    func fetchSessionInfo(sessionId: String,completion: @escaping (SessionModel?, CustomError?) -> Void) {
        service.fetchSessionInfo(sessionId: sessionId, completion: completion)
    }
    
}
