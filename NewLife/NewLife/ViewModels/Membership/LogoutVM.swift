//
//  LogoutVM.swift
//  NewLife
//
//  Created by Shadi on 12/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class LogoutVM: NSObject {

    let service: MembershipService!
    
    init(service: MembershipService) {
        self.service = service
    }
    
    func logout(completion: @escaping (_ error: CustomError?) -> Void) {
        service.logout { (error) in
            completion(error)
        }
    }
    
}
