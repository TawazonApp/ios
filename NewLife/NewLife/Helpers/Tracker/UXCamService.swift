//
//  UXCamService.swift
//  Tawazon
//
//  Created by mac on 07/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import UXCam

class UXCamTrackerService: TrackingService {
    
    
    enum CustomEvents {
        static let startSubscription = "purchase_process_sucess"
        static let unsbscribeTapped = "tap_unsubscribe"
        static let tapCancelSubscription = "cancel_payment_process"
        static let setGoal = "set_goal"
        static let tapCategory = "tap_category"
        static let tapSubCategory = "tap_sub_category"
        static let playSoundEffect = "play_sound_effect"
        static let playSession = "play_session"
        static let downloadSession = "download_session"
        static let likeSession = "like_session"
        static let sessionListenForPreiod = "session_listen_for_period"
        static let openMore = "open_more"
        static let openUserProfile = "open_user_profile"
        static let userChangeName = "user_change_name"
        static let userChangePhoto = "user_change_photo"
        static let userChangePassword = "user_change_password"
        static let openDownloadedLibrary = "open_downloaded_library"
        static let openPremium = "open_premium_view"
        static let closePremium = "close_premium_view"
        static let skipPremium = "skip_premium"
        static let tapProduct = "tap_product"
        static let startPaymentProcess = "Start_payment_process"
        static let FailToPurchase = "purchase_process_fail"
        static let notificationStatusChanged = "notification_status_changed"
        static let openSupport = "open_support"
        static let openOurStory = "open_our_story"
        static let openPrivacyPolicy = "open_privacy_policy"
        static let openTermsOfUse = "open_terms_of_use"
        static let successlogout = "success_logout"
        static let cancellogout = "cancel_logout"
        static let rateApp = "rate_app"
        static let shareApp = "share_app"
        static let openVoicesAndDialects = "open_voices_and_dialects"
    }
    
    func sendUserId(userId: String?) {
        UXCam.setUserIdentity(userId ?? "")
        UXCam.setUserProperty("idfa", value: UIApplication.identifierForAdvertising ?? "")
    }
    
    func sendLoginEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent("logged_in", withProperties: values)
    }
    
    func sendCompleteRegistrationEvent(method: RegistrationMethod) {
        var values = getBaseEventValues()
        values["login_method"] = method.rawValue
        UXCam.logEvent("registered", withProperties: values)
    }
    
    func sendStartSubscriptionEvent(productId: String, plan: PremiumPurchase?, price: Double, currency: String, trial: Bool) {
        let planString = plan?.getPlan() ?? ""
        var values = getBaseEventValues()
        values["item_name"] = productId
        values["plan"] = planString
        values["AnalyticsParameterPrice"] = price
        values["AnalyticsParameterCurrency"] = currency
        
        UXCam.logEvent(CustomEvents.startSubscription, withProperties: values)
    }
    
    func sendTapProductEvent(productId: String, name: String, price: Double) {
        var values = getBaseEventValues()
        values["id"] = productId
        values["name"] = name
        values["price"] = price
        
        UXCam.logEvent(CustomEvents.tapProduct, withProperties: values)
    }
    
    func sendStartPaymentProcessEvent(productId: String, name: String, price: Double) {
        var values = getBaseEventValues()
        values["id"] = productId
        values["name"] = name
        values["price"] = price
        
        UXCam.logEvent(CustomEvents.startPaymentProcess, withProperties: values)
    }
    
    func sendUnsbscribeButtonTappedEvent(productId: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = productId
        values["name"] = name
        
        UXCam.logEvent(CustomEvents.unsbscribeTapped, withProperties: values)
    }
    
    func sendTapCancelSubscriptionEvent(productId: String, plan: String) {
        var values = getBaseEventValues()
        values["item_name"] = productId
        values["plan"] = plan
        
        UXCam.logEvent(CustomEvents.tapCancelSubscription, withProperties: values)
    }
    
    func sendSetGoalEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        UXCam.logEvent(CustomEvents.setGoal, withProperties: values)
    }
    
    func sendTapCategoryEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        UXCam.logEvent(CustomEvents.tapCategory, withProperties: values)
    }
    
    func sendTapSubCategoryEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        UXCam.logEvent(CustomEvents.tapSubCategory, withProperties: values)
    }
    
    func sendPlaySoundEffectEvent(name: String) {
        var values = getBaseEventValues()
        values["name"] = name
        
        UXCam.logEvent(CustomEvents.playSoundEffect, withProperties: values)
    }
    
    func sendPlaySessionEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        UXCam.logEvent(CustomEvents.playSession, withProperties:  values)
    }
    
    func sendDownloadSessionEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        UXCam.logEvent(CustomEvents.downloadSession, withProperties: values)
    }
    
    func sendLikeSessionEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        UXCam.logEvent(CustomEvents.likeSession, withProperties: values)
    }
    
    func sendOpenMoreEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.openMore, withProperties: values)
    }
    
    func sendOpenUserProfileEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.openUserProfile, withProperties: values)
    }
    
    func sendUserChangeNameEvent(){
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.userChangeName, withProperties: values)
    }
    
    func sendUserChangePhotoEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.userChangePhoto, withProperties: values)
    }
    
    func sendUserChangePasswordEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.userChangePassword, withProperties: values)
    }
    
    func sendOpenDownloadedLibraryEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.openDownloadedLibrary, withProperties: values)
    }
    
    func sendOpenSectionSessionList(sectionId: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = sectionId
        values["name"] = name
        
        UXCam.logEvent(CustomEvents.openDownloadedLibrary, withProperties: values)
    }
    
    func sendOpenPremiumEvent(viewName: String) {
        var values = getBaseEventValues()
        values["premiumViewName"] = viewName
        UXCam.logEvent(CustomEvents.openPremium, withProperties: values)
    }
    
    func sendClosePremiumEvent(viewName: String) {
        var values = getBaseEventValues()
        values["premiumViewName"] = viewName
        
        UXCam.logEvent(CustomEvents.closePremium,
                       withProperties: values)
    }
    
    func sendSkipPremiumEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.skipPremium, withProperties: values)
    }
    
    func sendNotificationStatusChangedEvent(status: Bool) {
        var values = getBaseEventValues()
        values["status"] = status
        
        UXCam.logEvent(CustomEvents.notificationStatusChanged, withProperties: values)
    }
    
    func sendOpenSupportEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.openSupport, withProperties: values)
    }
    
    func sendOpenOurStoryEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.openOurStory, withProperties: values)
    }
    
    func sendOpenPrivacyPolicyEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.openPrivacyPolicy, withProperties: values)
    }
    
    func sendOpenTermsOfUseEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.openTermsOfUse, withProperties: values)
    }
    
    func sendSuccesslogoutEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.successlogout, withProperties: values)
    }
    
    func sendCancelLogoutEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.cancellogout, withProperties: values)
    }
    
    func sendRateAppEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.rateApp, withProperties: values)
    }
    
    func sendShareAppEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.shareApp, withProperties: values)
    }
    
    func sendSessionListenForPeriodEvent(period: Double, sessionId: String) {
        var values = getBaseEventValues()
        values["period"] = period
        values["id"] = sessionId
        UXCam.logEvent(CustomEvents.sessionListenForPreiod, withProperties: values)
    }
    
    func sendFailToPurchaseEvent(productId: String, plan: String, message: String) {
        var values = getBaseEventValues()
        values["item_name"] = productId
        values["plan"] = plan
        values["message"] = message
        UXCam.logEvent(CustomEvents.FailToPurchase, withProperties: values)
    }
    func sendOpenVoicesAndDialectsEvent(){
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.openVoicesAndDialects, withProperties: values)
    }
    private func getBaseEventValues() -> [String : Any] {
        return ["campaignId": UserDefaults.originalCampaignId() ?? "",
                "currentCampaignId": UserDefaults.currentCampaignId() ?? "",
                "is_premium" : UserDefaults.isPremium()]
    }
}
