//
//  NewMoreCellVM.swift
//  Tawazon
//
//  Created by mac on 13/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation

class MoreCellVM: NSObject{

    enum MoreCellType: CaseIterable {
        case userProfile
        case login
        case premium
        case moodStats
        case library
        case settings
    }
    
    let type: MoreCellType!
    var bgImageName: String?
    var imageName: String?
    var title: String!
    var detailedTitle: String!
    var subTitle: String?
    
    init(type: MoreCellType) {
        self.type = type
        super.init()
        self.bgImageName = bgImageName(type: type)
        self.title = title(type: type)
        self.detailedTitle = detailedTitle(type: type)
        self.subTitle = subTitle(type: type)
        self.imageName = imageName(type: type)
    }
}
extension MoreCellVM{
    private func bgImageName(type: MoreCellType) -> String{
        
        var name : String = ""
        switch type{
        case .moodStats:
            name = "MoreProgressStats"
            break
        default:
            name = ""
            
        }
        return name
    }
    
    private func title(type: MoreCellType) -> String {
        var title: String = ""
        switch type {
        case .userProfile:
            let isAnonymousUser = UserDefaults.isAnonymousUser()
            title = isAnonymousUser ? "MoreUserProfileTitle".localized : (UserInfoManager.shared.getUserInfo()?.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            break
        case .login:
             title = "MoreLoginTitle".localized
            break
        case .premium:
            title = "MorePremiumTitle".localized
            break
        case .moodStats:
            title = "MoreMoodStatsTitle".localized
            break
        case .library:
            title = "MoreDownloadLibraryTitle".localized
            break
        case .settings:
            title = "MoreSettingsTitle".localized
            break
        }
        return title
    }
    
    private func subTitle(type: MoreCellType) -> String {
        var subTitle: String = ""
        switch type {
        case .userProfile:
            subTitle = "MoreUserProfileSubTitle".localized
            break
        case .login:
            subTitle = "MoreLoginSubTitle".localized
            break
        case .moodStats:
            subTitle = "MoreMoodStatsSubTitle".localized
            break
        case .premium:
            subTitle = "MorePremiumSubTitle".localized
            break
        case .library:
            subTitle = "MoreDownloadLibrarySubTitle".localized
            break
        case .settings:
            subTitle = "MoreSettingsSubTitle".localized
            break
        
        }
        return subTitle
    }
    
    private func detailedTitle(type: MoreCellType) -> String {
        var detailedTitle: String = ""
        switch type {
        case .userProfile:
            let isAnonymousUser = UserDefaults.isAnonymousUser()
            detailedTitle = isAnonymousUser ? "MoreUserProfileTitle".localized : (UserInfoManager.shared.getUserInfo()?.email ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            break
        default:
            detailedTitle = ""
            break
        
        }
        return detailedTitle
    }
    
    private func imageName(type: MoreCellType) -> String{
        var name : String = ""
        switch type{
        case .userProfile:
            name = "MoreUserProfile"
            break
        case .login:
            name = "MoreUserProfile"
            break
        case .premium:
            name = "MorePremium"
            break
        case .moodStats:
            name = "MoreCharts"
            break
        case .settings:
            name = "MoreSettings"
            break
        default:
            name = ""
            
        }
        return name
    }
}
