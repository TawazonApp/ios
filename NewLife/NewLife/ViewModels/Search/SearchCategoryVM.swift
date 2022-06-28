//
//  SearchCategoryVM.swift
//  Tawazon
//
//  Created by mac on 27/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SearchCategoryVM: NSObject {
    var id: String!
    var name: String!
    var backgroundColor: UIColor!
    var gradiantColors: [CGColor]!
    var cellTextColor: UIColor!
    var cellBackgroundColor: UIColor!
    var sessions: [HomeSessionVM]!
    
    let searchCategory: SearchCategoryModel!
    
    init(sarchCategory: SearchCategoryModel, backgroundColor: UIColor, gradiantColors: [CGColor], cellTextColor: UIColor, cellBackgroundColor: UIColor) {
        
        self.searchCategory = sarchCategory
        
        self.id = sarchCategory.id
        self.name = sarchCategory.name
        
        self.backgroundColor = backgroundColor
        self.gradiantColors = gradiantColors
        self.cellTextColor = cellTextColor
        self.cellBackgroundColor = cellBackgroundColor
        
        sessions = sarchCategory.sessions?.map({ return HomeSessionVM(session: $0)})
        
    }
}
