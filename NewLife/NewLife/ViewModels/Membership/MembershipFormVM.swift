//
//  MembershipFormVM.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MembershipFormVM: NSObject {
    
    let service: MembershipService!
    
    var title: String! {
        return ""
    }
    
    var items: [Any] {
        return []
    }
    
    init(service: MembershipService) {
        self.service = service
    }
    
    func submit(completion: @escaping (_ error: CustomError?) -> Void) {
        
    }
}
