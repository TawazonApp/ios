//
//  DeleteVM.swift
//  Tawazon
//
//  Created by mac on 07/07/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class DeleteVM: NSObject {

    let service: MembershipService!
    
    init(service: MembershipService) {
        self.service = service
    }
    
    func deleteAccount(completion: @escaping (DeleteAccountModel?, CustomError?) -> Void) {
        service.deleteAccount { (deleteModel, error) in
            completion(deleteModel, error)
        }
    }
    
}
