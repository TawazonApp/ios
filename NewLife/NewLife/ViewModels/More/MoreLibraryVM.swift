//
//  MoreLibraryVM.swift
//  Tawazon
//
//  Created by mac on 17/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation
class MoreLibraryVM: NSObject {
    
    var items: [MoreLibraryCellVM]!
    
    override init() {
        super.init()
        self.items = buildItems()
    }
    
    private func buildItems() -> [MoreLibraryCellVM] {
        var items = [MoreLibraryCellVM]()
        let isAnonymousUser = UserDefaults.isAnonymousUser()
        
        var types = MoreLibraryCellVM.MoreLibraryCellType.allCases
        
        
        for type in types {
            items.append(MoreLibraryCellVM.init(type: type))
        }
        return items
    }
}
