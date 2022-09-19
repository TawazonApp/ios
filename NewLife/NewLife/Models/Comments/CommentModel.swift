//
//  CommentModel.swift
//  Tawazon
//
//  Created by mac on 19/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation

// MARK: - SeriesModel
struct CommentModel: Codable, ModelInitializable {
    let id, content, status: String?
    let rating: Int?
    let user: UserInfoModel
    let reactions: Reactions?
    let reacted: Bool?
    let rejectionNote: String?
    let createdAt, createdAtDiffForHumans: String?
    let replies: Int?
}

// MARK: - Reactions
struct Reactions: Codable {
    let love: Int?
}
