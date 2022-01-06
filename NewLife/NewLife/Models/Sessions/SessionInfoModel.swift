//
//  SessionInfoModel.swift
//  Tawazon
//
//  Created by Shadi on 30/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

struct SessionInfoModel: Codable, ModelInitializable {
    let status: Bool
    let session: SessionModel?
}
