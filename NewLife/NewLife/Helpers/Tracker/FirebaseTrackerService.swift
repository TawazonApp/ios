//
//  FirebaseTrackerManager.swift
//  Tawazon
//
//  Created by Shadi on 18/10/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import Firebase

class FirebaseTrackingService: TrackingService {
    enum CustomEvents {
        static let startSubscription = "start_subscription_trial"
        static let tapCancelSubscription = "tap_cancel_subscription"
        static let setGoal = "set_goal"
        static let tapCategory = "tap_category"
        static let tapSubCategory = "tap_sub_category"
        static let playSoundEffect = "play_sound_effect"
        static let playSession = "play_session"
        static let downloadSession = "download_session"
        static let likeSession = "like_session"
        static let openMore = "open_more"
        static let openUserProfile = "open_user_profile"
        static let userChangeName = "user_change_name"
        static let userChangePhoto = "user_change_photo"
        static let userChangePassword = "user_change_password"
        static let openDownloadedLibrary = "open_downloaded_library"
        static let openPremium = "open_premium"
        static let closePremium = "close_premium"
        static let skipPremium = "skip_premium"
        static let notificationStatusChanged = "notification_status_changed"
        static let openSupport = "open_support"
        static let openOurStory = "open_our_story"
        static let openPrivacyPolicy = "open_privacy_policy"
        static let openTermsOfUse = "open_terms_of_use"
        static let successlogout = "success_logout"
        static let cancellogout = "cancel_logout"
        static let rateApp = "rate_app"
        static let shareApp = "share_app"
    }
    
    func sendUserId(userId: String?) {
        Analytics.setUserID(userId)
        Analytics.setUserProperty(UIApplication.identifierForAdvertising, forName: "idfa")
    }
    
    func sendLoginEvent() {
        Analytics.logEvent(AnalyticsEventLogin, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                             "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendCompleteRegistrationEvent(method: RegistrationMethod) {
        Analytics.logEvent(AnalyticsEventSignUp, parameters: [AnalyticsParameterSignUpMethod: method.rawValue,
                                                              "campaignId": UserDefaults.originalCampaignId() ?? "",
                                                              "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendStartSubscriptionEvent(productId: String, plan: PremiumPurchase?, price: Double, currency: String, trial: Bool) {
        let planString = plan?.getPlan() ?? ""
        Analytics.logEvent(CustomEvents.startSubscription, parameters: [
            AnalyticsParameterItemID: productId,
            "plan" : planString,
            AnalyticsParameterPrice: price,
            AnalyticsParameterCurrency: currency,
            "campaignId": UserDefaults.originalCampaignId() ?? "",
            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendTapCancelSubscriptionEvent(productId: String, plan: String) {
        Analytics.logEvent(CustomEvents.tapCancelSubscription, parameters: [
            AnalyticsParameterItemID: productId,
            "plan" : plan,
            "campaignId": UserDefaults.originalCampaignId() ?? "",
            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendSetGoalEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.setGoal, parameters: [
            "id" : id,
            "name": name,
            "campaignId": UserDefaults.originalCampaignId() ?? "",
            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendTapCategoryEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.tapCategory, parameters: [
            "id" : id,
            "name": name,
            "campaignId": UserDefaults.originalCampaignId() ?? "",
            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendTapSubCategoryEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.tapSubCategory, parameters: [
            "id" : id,
            "name": name,
            "campaignId": UserDefaults.originalCampaignId() ?? "",
            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendPlaySoundEffectEvent(name: String) {
        Analytics.logEvent(CustomEvents.playSoundEffect, parameters: [
            "name": name,
            "campaignId": UserDefaults.originalCampaignId() ?? "",
            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendPlaySessionEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.playSession, parameters:  [
            "id" : id,
            "name": name,
            "campaignId": UserDefaults.originalCampaignId() ?? "",
            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendDownloadSessionEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.downloadSession, parameters: [
            "id" : id,
            "name": name,
            "campaignId": UserDefaults.originalCampaignId() ?? "",
            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendLikeSessionEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.likeSession, parameters: [
            "id" : id,
            "name": name,
            "campaignId": UserDefaults.originalCampaignId() ?? "",
            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendOpenMoreEvent() {
        Analytics.logEvent(CustomEvents.openMore, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                               "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendOpenUserProfileEvent() {
        Analytics.logEvent(CustomEvents.openUserProfile, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                      "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendUserChangeNameEvent() {
        Analytics.logEvent(CustomEvents.userChangeName, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                     "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendUserChangePhotoEvent() {
        Analytics.logEvent(CustomEvents.userChangePhoto, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                      "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendUserChangePasswordEvent() {
        Analytics.logEvent(CustomEvents.userChangePassword, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                         "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendOpenDownloadedLibraryEvent() {
        Analytics.logEvent(CustomEvents.openDownloadedLibrary, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendOpenSectionSessionList(sectionId: String, name: String) {
        Analytics.logEvent(CustomEvents.openDownloadedLibrary, parameters: [
                            "id" : sectionId,
                            "name": name,
                            "campaignId": UserDefaults.originalCampaignId() ?? "",
                            "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendOpenPremiumEvent() {
        Analytics.logEvent(CustomEvents.openPremium, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                  "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendClosePremiumEvent() {
        Analytics.logEvent(CustomEvents.closePremium, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                   "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendSkipPremiumEvent() {
        Analytics.logEvent(CustomEvents.skipPremium, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                  "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendNotificationStatusChangedEvent(status: Bool) {
        Analytics.logEvent(CustomEvents.notificationStatusChanged, parameters: ["status": status,
                                                                                "campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                                "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendOpenSupportEvent() {
        Analytics.logEvent(CustomEvents.openSupport, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                  "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendOpenOurStoryEvent() {
        Analytics.logEvent(CustomEvents.openOurStory, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                   "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendOpenPrivacyPolicyEvent() {
        Analytics.logEvent(CustomEvents.openPrivacyPolicy, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                        "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendOpenTermsOfUseEvent() {
        Analytics.logEvent(CustomEvents.openTermsOfUse, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                     "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendSuccesslogoutEvent() {
        Analytics.logEvent(CustomEvents.successlogout, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                    "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendCancelLogoutEvent() {
        Analytics.logEvent(CustomEvents.cancellogout, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                                   "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendRateAppEvent() {
        Analytics.logEvent(CustomEvents.rateApp, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                              "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
    
    func sendShareAppEvent() {
        Analytics.logEvent(CustomEvents.shareApp, parameters: ["campaignId": UserDefaults.originalCampaignId() ?? "",
                                                               "currentCampaignId": UserDefaults.currentCampaignId() ?? ""])
    }
}
