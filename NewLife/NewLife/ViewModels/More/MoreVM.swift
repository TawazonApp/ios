//
//  MoreVM.swift
//  NewLife
//
//  Created by Shadi on 28/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MoreVM: NSObject {
    
    var items: [MoreCellVM]!
    
    override init() {
        super.init()
        self.items = buildItems()
    }
    
    private func buildItems() -> [MoreCellVM] {
        var items = [MoreCellVM]()
        let isAnonymousUser = UserDefaults.isAnonymousUser()
        
        var types = MoreCellVM.MoreCellType.allCases
        var typesToDelete: [MoreCellVM.MoreCellType] = []
        
        isAnonymousUser ? typesToDelete.append(.userProfile) :  typesToDelete.append(.login)

        for typeToDelete in typesToDelete {
            if let index = types.firstIndex(of: typeToDelete) {
               types.remove(at: index)
            }
        }
        
        for type in types {
            if type == .notifications {
                items.append(MoreNotificationCellVM.init(service: MembershipServiceFactory.service(), type: type))
            } else {
                items.append(MoreCellVM.init(type: type))
            }
        }
        return items
    }
}
