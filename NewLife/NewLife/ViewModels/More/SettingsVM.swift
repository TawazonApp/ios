//
//  SettingsVM.swift
//  Tawazon
//
//  Created by mac on 18/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class SettingsVM: NSObject {
    
    var items: [SettingsCellVM]!
    
    override init() {
        super.init()
        self.items = buildItems()
    }
    
    private func buildItems() -> [SettingsCellVM] {
        var items = [SettingsCellVM]()
        let isAnonymousUser = UserDefaults.isAnonymousUser()
        
        var types = SettingsCellVM.SettingsCellType.allCases
        
        for type in types {
            if type == .notifications {
                items.append(NotificationCellVM.init(service: MembershipServiceFactory.service(), type: type))
            } else {
                items.append(SettingsCellVM.init(type: type))
            }
        }
        return items
    }
}


