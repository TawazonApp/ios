//
//  AppsFlyerTrackerManager.swift
//  Tawazon
//
//  Created by Shadi on 18/10/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AppsFlyerLib



class AppsFlyerTrackingService: TrackingService {
    enum CustomEvents {
        static let startSubscription = "af_start_subscription_trial"
        static let tapCancelSubscription = "af_tap_cancel_subscription"
        static let setGoal = "af_set_goal"
        static let tapCategory = "af_tap_category"
        static let tapSubCategory = "af_tap_sub_category"
        static let playSoundEffect = "af_play_sound_effect"
        static let playSession = "af_play_session"
        static let downloadSession = "af_download_session"
        static let likeSession = "af_like_session"
        static let sessionListenForPreiod = "af_session_listen_for_period"
        static let openMore = "af_open_more"
        static let openUserProfile = "af_open_user_profile"
        static let userChangeName = "af_user_change_name"
        static let userChangePhoto = "af_user_change_photo"
        static let userChangePassword = "af_user_change_password"
        static let openDownloadedLibrary = "af_open_downloaded_library"
        static let openSectionSessionList = "af_section_session_list"
        static let openPremium = "af_open_premium"
        static let closePremium = "af_close_premium"
        static let skipPremium = "af_skip_premium"
        static let FailToPurchase = "af_fail_to_purchase"
        static let notificationStatusChanged = "af_notification_status_changed"
        static let openSupport = "af_open_support"
        static let openOurStory = "af_open_our_story"
        static let openPrivacyPolicy = "af_open_privacy_policy"
        static let openTermsOfUse = "af_open_terms_of_use"
        static let successlogout = "af_success_logout"
        static let cancellogout = "af_cancel_logout"
        static let rateApp = "af_rate_app"
        static let shareApp = "af_share_app"
    }
    
    func sendUserId(userId: String?) {
        AppsFlyerLib.shared().customerUserID = userId
    }
    
    func sendLoginEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(AFEventLogin, withValues: values)
    }
    
    func sendCompleteRegistrationEvent(method: RegistrationMethod) {
        var values = getBaseEventValues()
        
        values[AFEventParamRegistrationMethod] = method.rawValue
        AppsFlyerLib.shared().logEvent(AFEventCompleteRegistration, withValues: values)
    }
    
    func sendStartSubscriptionEvent(productId: String, plan: PremiumPurchase?, price: Double, currency: String, trial: Bool) {
        var values = getBaseEventValues()
        values[AFEventParamContentId] = productId
        values["plan"] = plan?.getPlan ?? ""
        values[AFEventParamPrice] = price
        values[AFEventParamCurrency] = currency
        AppsFlyerLib.shared().logEvent(CustomEvents.startSubscription,
                                             withValues: values)
        
        
        values = getBaseEventValues()
        values[AFEventParamContentId] = productId
        values["plan"] = plan?.getPlan ?? ""
        values[AFEventParamPrice] = price
        values[AFEventParamCurrency] = currency
        
        var eventName = ""
        if trial {
            eventName = "af_app_purchase_\(plan?.eventPeriodName ?? "unknown")"
        } else {
            eventName = "af_app_trial_started_\(plan?.eventPeriodName ?? "unknown")"
        }
        AppsFlyerLib.shared().logEvent(eventName, withValues: values)
    }
    
    func sendTapCancelSubscriptionEvent(productId: String, plan: String) {
        var values = getBaseEventValues()
        values[AFEventParamContentId] = productId
        values["plan"] = plan
        
        AppsFlyerLib.shared().logEvent(CustomEvents.tapCancelSubscription,
                                             withValues: values)
    }
    
    func sendSetGoalEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        AppsFlyerLib.shared().logEvent(CustomEvents.setGoal,
                                             withValues: values)
    }
    
    func sendTapCategoryEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        AppsFlyerLib.shared().logEvent(CustomEvents.tapCategory,
                                             withValues: values)
    }
    
    func sendTapSubCategoryEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        AppsFlyerLib.shared().logEvent(CustomEvents.tapSubCategory,
                                             withValues: values)
    }
    
    func sendPlaySoundEffectEvent(name: String) {
        var values = getBaseEventValues()
        values["name"] = name
        
        AppsFlyerLib.shared().logEvent(CustomEvents.playSoundEffect,
                                             withValues: values)
    }
    
    func sendPlaySessionEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        AppsFlyerLib.shared().logEvent(CustomEvents.playSession,
                                             withValues: values)
    }
    
    func sendDownloadSessionEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        AppsFlyerLib.shared().logEvent(CustomEvents.downloadSession,
                                             withValues: values)
    }
    
    func sendLikeSessionEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        AppsFlyerLib.shared().logEvent(CustomEvents.likeSession,
                                             withValues: values)
    }
    
    func sendOpenMoreEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openMore,
                                             withValues: values)
    }
    
    func sendOpenUserProfileEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openUserProfile,
                                             withValues: values)
    }
    
    func sendUserChangeNameEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.userChangeName,
                                             withValues: values)
    }
    
    func sendUserChangePhotoEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.userChangePhoto,
                                             withValues: values)
    }
    
    func sendUserChangePasswordEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.userChangePassword,
                                             withValues: values)
    }
    
    func sendOpenDownloadedLibraryEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openDownloadedLibrary,
                                             withValues: values)
    }
    
    func sendOpenSectionSessionList(sectionId: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = sectionId
        values["name"] = name
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openSectionSessionList,
                                             withValues: values)
    }
    
    func sendOpenPremiumEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openPremium,
                                             withValues: values)
    }
    
    func sendClosePremiumEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.closePremium,
                                             withValues: values)
    }
    
    func sendSkipPremiumEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.skipPremium,
                                             withValues: values)
    }
    
    func sendNotificationStatusChangedEvent(status: Bool) {
        var values = getBaseEventValues()
        values["status"] = status
        
        AppsFlyerLib.shared().logEvent(CustomEvents.notificationStatusChanged,
                                             withValues: values)
    }
    
    func sendOpenSupportEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openSupport,
                                             withValues: values)
    }
    
    func sendOpenOurStoryEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openOurStory,
                                             withValues: values)
    }
    
    func sendOpenPrivacyPolicyEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openPrivacyPolicy,
                                             withValues: values)
    }
    
    func sendOpenTermsOfUseEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openTermsOfUse,
                                             withValues: values)
    }
    
    func sendSuccesslogoutEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.successlogout,
                                             withValues: values)
    }
    
    func sendCancelLogoutEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.cancellogout,
                                             withValues: values)
    }
    
    func sendRateAppEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.rateApp,
                                             withValues: values)
    }
    
    func sendShareAppEvent() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.shareApp,
                                             withValues: values)
        
    }
    
    private func getBaseEventValues() -> [AnyHashable : Any] {
        return ["idfa": UIApplication.identifierForAdvertising ?? "",
                "campaignId" : getCampaignId(),
                "currentCampaignId" :getCurrentCampaignId()]
    }
    private func getCampaignId() -> String{
        if let campaignId = UserDefaults.originalCampaignId() {
            return campaignId
        }
        else{
            return ""
        }
    }
    
    func sendSessionListenForPeriodEvent(period: Double, sessionId: String) {
        var values = getBaseEventValues()
        values["period"] = period
        values["id"] = sessionId
        AppsFlyerLib.shared().logEvent(CustomEvents.sessionListenForPreiod, withValues: values)
    }
    
    func sendFailToPurchaseEvent(message: String) {
        var values = getBaseEventValues()
        values["message"] = message
        AppsFlyerLib.shared().logEvent(CustomEvents.FailToPurchase, withValues: values)
    }
    
    private func getCurrentCampaignId() -> String{
        if let currentCampaignId = UserDefaults.currentCampaignId() {
            return currentCampaignId
        }
        else{
            return ""
        }
    }
}
