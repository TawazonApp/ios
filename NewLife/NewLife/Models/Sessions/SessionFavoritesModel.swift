//
//  SessionFavoritesModel.swift
//  NewLife
//
//  Created by Shadi on 18/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct SessionFavoritesModel: Codable, ModelInitializable {
    var favorites: [SessionModel]!
    
    enum CodingKeys: String, CodingKey {
        case favorites = "items"
    }
    
    init(favorites: [SessionModel]) {
        self.favorites = favorites
    }
}
