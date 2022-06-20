//
//  UserInfoModel.swift
//  NewLife
//
//  Created by Shadi on 11/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct UserInfoModel: Codable, ModelInitializable {
    let id, name, email: String?
    let premium: UserPremiumModel?
    var image: String?
    let settings: UserSettings?
    func isPremium() -> Bool {
        return premium != nil
    }
}
struct UserPremiumModel: Codable, ModelInitializable {
    let productID: String!
    let expireDate: Date?
    let price: String?
    let isTrialPeriod: Int?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case expireDate = "expiration_date"
        case price
        case isTrialPeriod = "is_trial"
    }
}

struct UserSettings: Codable, ModelInitializable {
    let defaultAudioSource: String
}


