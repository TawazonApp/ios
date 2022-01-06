//
//  SessionPlayerMananger.swift
//  NewLife
//
//  Created by Shadi on 20/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class SessionPlayerMananger: NSObject {
    
    static let shared = SessionPlayerMananger()
    var session: SessionVM?
    
    private override init() { }
}
