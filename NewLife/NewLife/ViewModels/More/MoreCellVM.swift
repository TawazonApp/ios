//
//  MoreCellVM.swift
//  NewLife
//
//  Created by Shadi on 28/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MoreCellVM: NSObject {
    
    enum MoreCellType: CaseIterable {
        case userProfile
        case login
        case downloadedLibrary
        case favorites
        case premium
        case notifications
        case lanaguge
        case support
        case privacyPolicy
        case termsAndConditions
        case ourStory
        case appVersion
        
        
    }
    
    let type: MoreCellType!
    var imageName: String?
    var title: String!
    var subTitle: String?
    
    init(type: MoreCellType) {
        self.type = type
        super.init()
        self.imageName = imageName(type: type)
        self.title = title(type: type)
        self.subTitle = subTitle(type: type)
    }
}

extension MoreCellVM {
    
    private func imageName(type: MoreCellType) -> String {
        var name: String = ""
        switch type {
        case .userProfile:
            name = "MoreUserProfile"
            break
        case .login:
            name = "MoreUserProfile"
            break
        case .downloadedLibrary:
            name = "MoreDownloadLibrary"
            break
        case .favorites:
            name = "MoreFavorites"
            break
        case .premium:
            name = "MorePremium"
            break
        case .notifications:
            name = "MoreNotifications"
            break
        case .lanaguge:
            name = "LanguageIcon"
            break
        case .support:
            name = "MoreSupport"
            break
        case .privacyPolicy:
            name = "MorePrivacyPolicy"
            break
        case .termsAndConditions:
            name = "MoreTermsAndConditions"
            break
        case .ourStory:
            name = "MoreOurStory"
            break
        case .appVersion:
            name = ""
            break
        }
        return name
    }
    
    private func title(type: MoreCellType) -> String {
        var title: String = ""
        switch type {
        case .userProfile:
            title = "MoreUserProfileTitle".localized
            break
        case .login:
             title = "MoreLoginTitle".localized
            break
        case .downloadedLibrary:
            title = "MoreDownloadLibraryTitle".localized
            break
        case .favorites:
            title = "MoreFavoritesTitle".localized
            break
        case .premium:
            title = "MorePremiumTitle".localized
            break
        case .notifications:
            title = "MoreNotificationsTitle".localized
            break
        case .lanaguge:
            title = "changeLanguageCellTitle".localized
            break
        case .support:
            title = "MoreSupportTitle".localized
            break
        case .privacyPolicy:
            title = "MorePrivacyPolicyTitle".localized
            break
        case .termsAndConditions:
            title = "MoreTermsAndConditionsTitle".localized
            break
        case .ourStory:
            title = "MoreOurStoryTitle".localized
            break
        case .appVersion:
            title = "moreAppVersionTitle".localized
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
        case .downloadedLibrary:
            subTitle = "MoreDownloadLibrarySubTitle".localized
            break
        case .favorites:
            subTitle = "MoreFavoritesSubTitle".localized
            break
        case .premium:
            subTitle = "MorePremiumSubTitle".localized
            break
        case .notifications:
            subTitle = "MoreNotificationsSubTitle".localized
            break
        case .lanaguge:
            subTitle = "changeLanguageAlertTitle".localized
        case .support:
            subTitle = "MoreSupportSubTitle".localized
            break
        case .privacyPolicy:
            subTitle = "MorePrivacyPolicySubTitle".localized
            break
        case .termsAndConditions:
            subTitle = "MoreTermsAndConditionsSubTitle".localized
            break
        case .ourStory:
            subTitle = "MoreOurStorySubTitle".localized
            break
        case .appVersion:
            subTitle = "moreAppVersionSubTitle".localized.appending(" \(UIApplication.appVersion)")
            break
            
        }
        return subTitle
    }
}

class MoreNotificationCellVM: MoreCellVM {
    
    let service: MembershipService!
    var notificationModel: NotificationStatusModel?
    
    var switchValue: Bool?  {
        return notificationModel?.status.boolValue()
    }
    
    init(service: MembershipService, type: MoreCellType) {
        self.service = service
        super.init(type: type)
    }
    
    func fetchStatusIfNeeded(completion: @escaping (CustomError?) -> Void) {
        if notificationModel != nil {
            completion(nil)
            return
        }
        fetchStatus { (error) in
            completion(error)
        }
    }
    
    private func fetchStatus(completion: @escaping (CustomError?) -> Void) {
        
        service.notificationStatus { [weak self] (notificationModel, error) in
            if notificationModel != nil {
                self?.notificationModel = notificationModel!
            }
            completion(error)
        }
    }
    
    func changeStatus(status: Bool, completion: @escaping (CustomError?) -> Void) {
        
        service.changeNotificationStatus(data: NotificationStatusModel(status: status.intValue())) { [weak self](error) in
             self?.notificationModel?.status = status.intValue()
            completion(error)
        }
    }
    
}
