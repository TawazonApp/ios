//
//  ProfileCellVM.swift
//  NewLife
//
//  Created by Shadi on 12/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ProfileCellVM: NSObject {

    enum Types: CaseIterable {
        case changeUserName
        case changeProfilePicture
        case changePassword
        case changeToPremium
        case logout
    }
    
    let type: Types!
    var imageName: String!
    var title: String!
    
    init(type: Types) {
        self.type = type
        super.init()
        let result = titleAndImage(type: type)
        self.imageName = result.imageName
        self.title = result.title
    }
    
    private func titleAndImage(type: Types) -> (title: String, imageName: String) {
        var result = (title: "", imageName: "String")
        switch type {
        case .changeUserName:
            result.title = "profileChangeUserNameTitle".localized
            result.imageName = "ProfileUserName"
            break
        case .changeProfilePicture:
            result.title = "profileChangeProfilePictureTitle".localized
            result.imageName = "ProfilePicture"
            break
        case .changeToPremium:
            result.title = "profileChangeToPremiumTitle".localized
            result.imageName = "ProfilePremium"
            break
        case .changePassword:
            result.title = "profileChangePasswordTitle".localized
            result.imageName = "ProfilePassword"
            break
        case .logout:
            result.title = "profileLogoutTitle".localized
            result.imageName = "ProfileLogout"
            break
        
        }
        return result
    }
}
