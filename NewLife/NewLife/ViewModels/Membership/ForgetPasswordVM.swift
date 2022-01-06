//
//  ForgetPasswordVM.swift
//  NewLife
//
//  Created by Shadi on 12/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ForgetPasswordVM: NSObject {
    
    let service: MembershipService!
    
    var title: String! {
        return ""
    }
    
    var subTitle: String! {
        return ""
    }
    
    var items: [Any] {
        return []
    }
    
    init(service: MembershipService) {
        self.service = service
    }
    
    func submit(completion: @escaping (_ email: String?, _ error: CustomError?) -> Void) {
        
    }
}
