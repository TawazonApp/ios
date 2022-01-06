//
//  PremiumCellVM.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumFeatureCellVM: NSObject {

    var iconAEName: String!
    var title: String!
    
    init(title: String, iconAEName: String) {
        self.title = title
        self.iconAEName = iconAEName
    }
}
