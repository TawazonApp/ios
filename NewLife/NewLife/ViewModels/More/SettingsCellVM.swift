//
//  SettingsCellVM.swift
//  Tawazon
//
//  Created by mac on 18/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class SettingsCellVM: NSObject {
    enum SettingsCellType: CaseIterable {
        case notifications
        case lanaguge
        case reminder
        case support
        case privacyPolicy
        case termsAndConditions
        case ourStory
        case appVersion
    }
    
    let type: SettingsCellType!
    var imageName: String?
    var title: String!
    var subTitle: String?
    
    init(type: SettingsCellType) {
        self.type = type
        super.init()
        
        self.title = title(type: type)
        self.subTitle = subTitle(type: type)
        self.imageName = imageName(type: type)
    }
}
extension SettingsCellVM{
    private func title(type: SettingsCellType) -> String {
        var title: String = ""
        switch type {
        case .notifications:
            title = "MoreNotificationsTitle".localized
            break
        case .lanaguge:
            title = "changeLanguageCellTitle".localized
            break
        case .reminder:
            title = "MoreReminderCellTitle".localized
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
    
    private func subTitle(type: SettingsCellType) -> String {
        var subTitle: String = ""
        switch type {
        case .notifications:
            subTitle = "MoreNotificationsSubTitle".localized
            break
        case .lanaguge:
            subTitle = "changeLanguageAlertTitle".localized
            break
        case .reminder:
            subTitle = "MoreReminderCellSubTitle".localized
            break
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
    
    private func imageName(type: SettingsCellType) -> String{
        var name : String = ""
        switch type {
        case .notifications:
            name = "MoreNotifications"
            break
        case .lanaguge:
            name = "LanguageIcon"
            break
        case .reminder:
            name = "MoreReminder"
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
}

class NotificationCellVM: SettingsCellVM {
    
    let service: MembershipService!
    var notificationModel: NotificationStatusModel?
    
    var switchValue: Bool?  {
        return notificationModel?.status.boolValue()
    }
    
    init(service: MembershipService, type: SettingsCellVM.SettingsCellType) {
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
