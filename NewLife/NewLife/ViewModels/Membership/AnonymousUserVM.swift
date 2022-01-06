//
//  AnonymousUserVM.swift
//  NewLife
//
//  Created by Shadi on 23/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class AnonymousUserVM: NSObject {

    func submit() {
        UserDefaults.saveUserToken(token: Api.anonymousToken)
        TrackerManager.shared.sendCompleteRegistrationEvent(method: .anonymous)
    }
}
