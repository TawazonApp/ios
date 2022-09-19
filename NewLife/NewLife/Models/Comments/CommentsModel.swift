//
//  CommentsModel.swift
//  Tawazon
//
//  Created by mac on 19/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
struct CommentsModel: Codable, ModelInitializable {
    var list: [CommentModel]
    
    enum CodingKeys: String, CodingKey{
        case list = "items"
    }
}
