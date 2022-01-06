//
//  SessionFavoritesModel.swift
//  NewLife
//
//  Created by Shadi on 18/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct SessionFavoritesModel: Codable, ModelInitializable {
    var favorites: [String]!
    
    init(favorites: [String]) {
        self.favorites = favorites
    }
}
