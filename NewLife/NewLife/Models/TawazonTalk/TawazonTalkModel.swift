//
//  TawazonTalk.swift
//  Tawazon
//
//  Created by mac on 18/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
struct TawazonTalkModel: Codable, ModelInitializable{
    let id: String
    let title, image, thumbnail, content, paletteColor: String?
    let author: Contributor?
    let mainItem: SessionModel
    let sections: [TawazonTalkSection]?
}

struct TawazonTalkSection: Codable, ModelInitializable {
    let title: String
    let items: [SessionModel]
}
