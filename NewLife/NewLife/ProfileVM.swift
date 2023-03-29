//
//  ProfileVM.swift
//  NewLife
//
//  Created by Shadi on 12/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ProfileVM: NSObject {
    
    let service: MembershipService!
    var userInfo: UserInfoModel?
    
    init(service: MembershipService) {
        self.service = service
    }
    
    var name: String? {
        return userInfo?.name
    }
    
    var displayName: String? {
        return userInfo?.displayName
    }
    
    var email: String? {
        return userInfo?.email
    }
    
    var imageUrl: String? {
        return userInfo?.image
    }
    
    var isPremium: Bool {
        return userInfo?.isPremium() ?? false
    }
    
    var premiumString: String {
        return isPremium ? "profilePremiumAccountText".localized : "profileBasicAccountText".localized
    }
    
    var premiumGradiantColors: [UIColor] {
        return isPremium ? [UIColor.periwinkleBlueThree, UIColor.carolinaBlue] : [UIColor.darkishPink, UIColor.salmonTwo]
    }
    
    var profileImageUploading: UIImage? {
      return UserInfoManager.shared.profileImageUploading
    }
    
    var tableItems: [ProfileCellVM] {
        var items = [ProfileCellVM]()
        
        if userInfo != nil {
            for type in ProfileCellVM.Types.allCases {
                
                if type != .changeToPremium || isPremium == false {
                    let item = ProfileCellVM(type: type)
                    items.append(item)
                }
            }
        }
        return items
    }
    
    func userInfo(completion: @escaping (_ error: CustomError?) -> Void) {
        if let userInfo = UserInfoManager.shared.getUserInfo() {
            self.userInfo = userInfo
            completion(nil)
        }
        fetchUserInfo { (error) in
            completion(error)
        }
    }
    
    private func fetchUserInfo(premium: Bool? = nil, completion: @escaping (_ error: CustomError?) -> Void) {
        service.fetchUserInfo(premium: premium) { [weak self] (userModel, error) in
            if error == nil {
                self?.userInfo = userModel
                UserInfoManager.shared.setUserInfo(userInfo: userModel)
                UserInfoManager.shared.setUserSettings()
            }
            completion(error)
        }
    }
    
    func uploadProfileImage(image:UIImage, completion: @escaping (_ error: CustomError?) -> Void) {
        UserInfoManager.shared.uploadProfileImage(service: service, image: image) { [weak self] (error) in
            if error == nil {
                self?.userInfo(completion: { (userError) in
                    completion(userError)
                })
                
            } else {
                completion(error)
            }
        }
    }
    
    func removeProfileImage(completion: @escaping (_ error: CustomError?) -> Void) {
        UserInfoManager.shared.removeProfileImage(service: service) { [weak self] (error) in
            if error == nil {
                self?.userInfo(completion: { (userError) in
                    completion(userError)
                })
                
            } else {
                completion(error)
            }
        }
    }
}
