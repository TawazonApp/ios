//
//  CategoryModel.swift
//  NewLife
//
//  Created by Shadi on 14/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct CategoryModel: Codable, ModelInitializable {
    var id: String?
    var title: String?
    var subCategories: [SubCategoryModel]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subCategories = "sub_categories"
    }
}
