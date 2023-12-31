//
//  NotificationData.swift
//  Raya
//
//  Created by Shadi on 31/10/2018.
//  Copyright © 2018 Inception. All rights reserved.
//

import UIKit

enum NotificationType:String {
    case playSession = "play_session"
    case category = "category"
    case none = ""
}

enum NotificationAppStatus {
    case foreground
    case background
    case launch
}

class NotificationData: NSObject {
    var type: NotificationType = .none
    var appStatus: NotificationAppStatus = .foreground
    var data: Any? = nil
    init(type: NotificationType, data: Any?, appStatus: NotificationAppStatus) {
        super.init()
        self.type = type
        self.data = data
        self.appStatus = appStatus
    }
}
