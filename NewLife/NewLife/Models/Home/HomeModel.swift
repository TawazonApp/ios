//
//  HomeModel.swift
//  NewLife
//
//  Created by Shadi on 16/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct HomeModel: Codable, ModelInitializable {
    var session: SessionModel!
}

extension HomeModel {
    
    init(session: SessionModel) {
        self.session = session
    }
}
