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
        static let startSubscription = "purchase_process_success"
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
        static let startPaymentProcess = "start_payment_process"
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
        static let changeVoicesAndDialects = "change_voices_and_dialects"
        static let openSearch = "open_search_view"
        static let searchFor = "search_for"
        static let playSessionFromSearch = "play_session_from_search"
        static let openSeries = "open_series"
        static let startGuidedTour = "guided_tour_started"
        static let closeGuidedTour = "guided_tour_closed"
        static let restartGuidedTour = "tap_restart_tutorial"
    }
    
    func sendUserId(userId: String?) {
        Analytics.setUserID(userId)
        Analytics.setUserProperty(UIApplication.identifierForAdvertising, forName: "idfa")
        Analytics.setUserProperty("\(UserDefaults.isPremium())", forName: "is_premium")
    }
    
    func sendLoginEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(AnalyticsEventLogin, parameters: values)
    }
    
    func sendCompleteRegistrationEvent(method: RegistrationMethod) {
        var values = getBaseEventValues()
        values[AnalyticsParameterSignUpMethod] = method.rawValue
        Analytics.logEvent(AnalyticsEventSignUp, parameters: values)
    }
    
    func sendStartSubscriptionEvent(productId: String, plan: PremiumPurchase?, price: Double, currency: String, trial: Bool) {
        let planString = plan?.getPlan() ?? ""
        var values = getBaseEventValues()
        values[AnalyticsParameterItemID] = productId
        values["plan"] = planString
        values["AnalyticsParameterPrice"] = price
        values["AnalyticsParameterCurrency"] = currency
        
        Analytics.logEvent(CustomEvents.startSubscription, parameters: values)
    }
    
    func sendTapProductEvent(productId: String, name: String, price: Double) {
        var values = getBaseEventValues()
        values["id"] = productId
        values["name"] = name
        values["price"] = price
        
        Analytics.logEvent(CustomEvents.tapProduct, parameters: values)
    }
    
    func sendStartPaymentProcessEvent(productId: String, name: String, price: Double) {
        var values = getBaseEventValues()
        values["id"] = productId
        values["name"] = name
        values["price"] = price
        
        Analytics.logEvent(CustomEvents.startPaymentProcess, parameters: values)
    }
    
    func sendUnsbscribeButtonTappedEvent(productId: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = productId
        values["name"] = name
        
        Analytics.logEvent(CustomEvents.unsbscribeTapped, parameters: values)
    }
    
    func sendTapCancelSubscriptionEvent(productId: String, plan: String) {
        var values = getBaseEventValues()
        values[AnalyticsParameterItemID] = productId
        values["plan"] = plan
        
        Analytics.logEvent(CustomEvents.tapCancelSubscription, parameters: values)
    }
    
    func sendSetGoalEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        Analytics.logEvent(CustomEvents.setGoal, parameters: values)
    }
    
    func sendTapCategoryEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        Analytics.logEvent(CustomEvents.tapCategory, parameters: values)
    }
    
    func sendTapSubCategoryEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        Analytics.logEvent(CustomEvents.tapSubCategory, parameters: values)
    }
    
    func sendPlaySoundEffectEvent(name: String) {
        var values = getBaseEventValues()
        values["name"] = name
        
        Analytics.logEvent(CustomEvents.playSoundEffect, parameters: values)
    }
    
    func sendPlaySessionEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        Analytics.logEvent(CustomEvents.playSession, parameters:  values)
    }
    
    func sendDownloadSessionEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        Analytics.logEvent(CustomEvents.downloadSession, parameters: values)
    }
    
    func sendLikeSessionEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = id
        values["name"] = name
        
        Analytics.logEvent(CustomEvents.likeSession, parameters: values)
    }
    
    func sendOpenMoreEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.openMore, parameters: values)
    }
    
    func sendOpenUserProfileEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.openUserProfile, parameters: values)
    }
    
    func sendUserChangeNameEvent(){
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.userChangeName, parameters: values)
    }
    
    func sendUserChangePhotoEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.userChangePhoto, parameters: values)
    }
    
    func sendUserChangePasswordEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.userChangePassword, parameters: values)
    }
    
    func sendOpenDownloadedLibraryEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.openDownloadedLibrary, parameters: values)
    }
    
    func sendOpenSectionSessionList(sectionId: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = sectionId
        values["name"] = name
        
        Analytics.logEvent(CustomEvents.openDownloadedLibrary, parameters: values)
    }
    
    func sendOpenPremiumEvent(viewName: String) {
        var values = getBaseEventValues()
        values["premiumViewName"] = viewName
        Analytics.logEvent(CustomEvents.openPremium, parameters: values)
    }
    
    func sendClosePremiumEvent(viewName: String) {
        var values = getBaseEventValues()
        values["premiumViewName"] = viewName
        
        Analytics.logEvent(CustomEvents.closePremium,
                           parameters: values)
    }
    
    func sendSkipPremiumEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.skipPremium, parameters: values)
    }
    
    func sendNotificationStatusChangedEvent(status: Bool) {
        var values = getBaseEventValues()
        values["status"] = status
        
        Analytics.logEvent(CustomEvents.notificationStatusChanged, parameters: values)
    }
    
    func sendOpenSupportEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.openSupport, parameters: values)
    }
    
    func sendOpenOurStoryEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.openOurStory, parameters: values)
    }
    
    func sendOpenPrivacyPolicyEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.openPrivacyPolicy, parameters: values)
    }
    
    func sendOpenTermsOfUseEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.openTermsOfUse, parameters: values)
    }
    
    func sendSuccesslogoutEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.successlogout, parameters: values)
    }
    
    func sendCancelLogoutEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.cancellogout, parameters: values)
    }
    
    func sendRateAppEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.rateApp, parameters: values)
    }
    
    func sendShareAppEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.shareApp, parameters: values)
    }
    
    func sendSessionListenForPeriodEvent(period: Double, sessionId: String) {
        var values = getBaseEventValues()
        values["period"] = period
        values["id"] = sessionId
        Analytics.logEvent(CustomEvents.sessionListenForPreiod, parameters: values)
    }
    
    func sendOpenSearchEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.openSearch, parameters: values)
    }
    
    func sendSearchFor(query: String) {
        var values = getBaseEventValues()
        values["query"] = query
        Analytics.logEvent(CustomEvents.searchFor, parameters: values)
    }
    
    func sendTapPlaySessionFromSearchResultEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["name"] = name
        values["id"] = id
        Analytics.logEvent(CustomEvents.playSessionFromSearch, parameters: values)
    }
    
    func sendFailToPurchaseEvent(productId: String, plan: String, message: String) {
        var values = getBaseEventValues()
        values[AnalyticsParameterItemID] = productId
        values["plan"] = plan
        values["message"] = message
        Analytics.logEvent(CustomEvents.FailToPurchase, parameters: values)
    }
    
    func sendOpenVoicesAndDialectsEvent() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.openVoicesAndDialects, parameters: values)
    }
    
    func sendChangeVoicesAndDialectsEvent(voice: String, dialect: String){
        var values = getBaseEventValues()
        values["voice"] = voice
        values["dialect"] = dialect
        Analytics.logEvent(CustomEvents.changeVoicesAndDialects, parameters: values)
    }
    
    func sendOpenSeries(id: String) {
        var values = getBaseEventValues()
        values["seriesId"] = id
        
        Analytics.logEvent(CustomEvents.openSeries, parameters: values)
    }
    
    func sendGuidedTourStarted(viewName: String) {
        var values = getBaseEventValues()
        values["viewName"] = viewName
        
        Analytics.logEvent(CustomEvents.startGuidedTour, parameters: values)
    }
    
    func sendGuidedTourClosed(isAllSteps: Bool, viewName: String, stepTitle: String, stepNumber: Int) {
        var values = getBaseEventValues()
        values["viewName"] = viewName
        values["isFinishedAllSteps"] = isAllSteps
        values["stepTitle"] = stepTitle
        values["stepNumber"] = stepNumber
        
        Analytics.logEvent(CustomEvents.closeGuidedTour, parameters: values)
    }
    
    func sendGuidedTourRestarted() {
        let values = getBaseEventValues()
        
        Analytics.logEvent(CustomEvents.restartGuidedTour, parameters: values)
    }
    
    private func getBaseEventValues() -> [String : Any] {
        return ["campaignId": UserDefaults.originalCampaignId() ?? "",
                "currentCampaignId": UserDefaults.currentCampaignId() ?? "",
                "is_premium" : UserDefaults.isPremium()]
    }
}
