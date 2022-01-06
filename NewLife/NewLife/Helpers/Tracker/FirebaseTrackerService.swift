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
        Analytics.logEvent(AnalyticsEventLogin, parameters: [:])
    }
    
    func sendCompleteRegistrationEvent(method: RegistrationMethod) {
        Analytics.logEvent(AnalyticsEventSignUp, parameters: [AnalyticsParameterSignUpMethod: method.rawValue])
    }
    
    func sendStartSubscriptionEvent(productId: String, plan: PremiumPurchase?, price: Double, currency: String, trial: Bool) {
        let planString = plan?.getPlan() ?? ""
        Analytics.logEvent(CustomEvents.startSubscription, parameters: [
            AnalyticsParameterItemID: productId,
            "plan" : planString,
            AnalyticsParameterPrice: price,
            AnalyticsParameterCurrency: currency])
    }
    
    func sendTapCancelSubscriptionEvent(productId: String, plan: String) {
        Analytics.logEvent(CustomEvents.tapCancelSubscription, parameters: [
            AnalyticsParameterItemID: productId,
            "plan" : plan])
    }
    
    func sendSetGoalEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.setGoal, parameters: [
            "id" : id,
            "name": name])
    }
    
    func sendTapCategoryEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.tapCategory, parameters: [
            "id" : id,
            "name": name])
    }
    
    func sendTapSubCategoryEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.tapSubCategory, parameters: [
            "id" : id,
            "name": name])
    }
    
    func sendPlaySoundEffectEvent(name: String) {
        Analytics.logEvent(CustomEvents.playSoundEffect, parameters: [
            "name": name])
    }
    
    func sendPlaySessionEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.playSession, parameters:  [
            "id" : id,
            "name": name])
    }
    
    func sendDownloadSessionEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.downloadSession, parameters: [
            "id" : id,
            "name": name])
    }
    
    func sendLikeSessionEvent(id: String, name: String) {
        Analytics.logEvent(CustomEvents.likeSession, parameters: [
            "id" : id,
            "name": name])
    }
    
    func sendOpenMoreEvent() {
        Analytics.logEvent(CustomEvents.openMore, parameters: [:])
    }
    
    func sendOpenUserProfileEvent() {
        Analytics.logEvent(CustomEvents.openUserProfile, parameters: [:])
    }
    
    func sendUserChangeNameEvent() {
        Analytics.logEvent(CustomEvents.userChangeName, parameters: [:])
    }
    
    func sendUserChangePhotoEvent() {
        Analytics.logEvent(CustomEvents.userChangePhoto, parameters: [:])
    }
    
    func sendUserChangePasswordEvent() {
        Analytics.logEvent(CustomEvents.userChangePassword, parameters: [:])
    }
    
    func sendOpenDownloadedLibraryEvent() {
        Analytics.logEvent(CustomEvents.openDownloadedLibrary, parameters: [:])
    }
    
    func sendOpenSectionSessionList(sectionId: String, name: String) {
        Analytics.logEvent(CustomEvents.openDownloadedLibrary, parameters: [
                            "id" : sectionId,
                            "name": name])
    }
    
    func sendOpenPremiumEvent() {
        Analytics.logEvent(CustomEvents.openPremium, parameters: [:])
    }
    
    func sendClosePremiumEvent() {
        Analytics.logEvent(CustomEvents.closePremium, parameters: [:])
    }
    
    func sendSkipPremiumEvent() {
        Analytics.logEvent(CustomEvents.skipPremium, parameters: [:])
    }
    
    func sendNotificationStatusChangedEvent(status: Bool) {
        Analytics.logEvent(CustomEvents.notificationStatusChanged, parameters: ["status": status])
    }
    
    func sendOpenSupportEvent() {
        Analytics.logEvent(CustomEvents.openSupport, parameters: [:])
    }
    
    func sendOpenOurStoryEvent() {
        Analytics.logEvent(CustomEvents.openOurStory, parameters: [:])
    }
    
    func sendOpenPrivacyPolicyEvent() {
        Analytics.logEvent(CustomEvents.openPrivacyPolicy, parameters: [:])
    }
    
    func sendOpenTermsOfUseEvent() {
        Analytics.logEvent(CustomEvents.openTermsOfUse, parameters: [:])
    }
    
    func sendSuccesslogoutEvent() {
        Analytics.logEvent(CustomEvents.successlogout, parameters: [:])
    }
    
    func sendCancelLogoutEvent() {
        Analytics.logEvent(CustomEvents.cancellogout, parameters: [:])
    }
    
    func sendRateAppEvent() {
        Analytics.logEvent(CustomEvents.rateApp, parameters: [:])
    }
    
    func sendShareAppEvent() {
        Analytics.logEvent(CustomEvents.shareApp, parameters: [:])
    }
}
