//
//  ErrorModel.swift
//  NewLife
//
//  Created by Shadi on 11/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct ErrorModel: Codable, ModelInitializable {
    let status: Bool
    let message: String
}

class CustomError: NSError {
    
   static let customErrorCode = 10000
    
    var message: String? = nil
    
    init(message: String?, statusCode: Int?) {
        let code = statusCode ?? CustomError.customErrorCode
        super.init(domain: "", code: code, userInfo: nil)
        self.message = message
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
