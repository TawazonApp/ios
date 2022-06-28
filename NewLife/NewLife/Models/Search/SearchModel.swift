//
//  SearchModel.swift
//  Tawazon
//
//  Created by mac on 27/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation

struct SearchModel: Codable, ModelInitializable {
    let sections: [HomeSectionModel]
    let categories: [SearchCategoryModel]
}
