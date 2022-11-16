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
        static let setAppLang = "set_app_language"
        static let setInstallSource = "set_install_source"
        static let closeInstallSource = "close_install_source"
        static let openCommentsView = "open_comments_view"
        static let openWriteCommentView = "open_write_comment_view"
        static let submitComment = "submit_comment"
        static let cancelSubmitComment = "cancel_submit_comment"
        static let startPrepFromButton = "startPrep_fromButton"
        static let startPrepFromImage = "startPrep_fromImage"
        static let startPrepSkipped = "startPrep_skipped"
        static let prepSessionBgSound = "prepSession_bgSound"
        static let prepSessionSkipped = "prepSession_skipped"
        static let prepSessionProgressTaped = "prepSession_progressTaped"
        static let prepSessionFinished = "prepSession_finished"
        static let feelingsMainSelected = "feelings_mainSelected"
        static let feelingsIntencitySelcted = "feelings_intencitySelcted"
        static let feelingsLogged = "feelings_logged"
        static let feelingsSkipped = "feelings_skipped"
        static let reminderDayTapped = "reminder_dayTapped"
        static let reminderTimeSelected = "reminder_timeSelected"
        static let reminderSet = "reminder_set"
        static let reminderSkipped = "reminder_skipped"
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
    
    func sendSetAppLanguage(language: String) {
        var values = getBaseEventValues()
        values["language"] = language
        values["deviceLanguage"] = NSLocale.current.languageCode
        
        Analytics.logEvent(CustomEvents.setAppLang, parameters: values)
    }
    
    func sendSetInstallSource(installSource: String) {
        var values = getBaseEventValues()
        values["installSource"] = installSource
        
        Analytics.logEvent(CustomEvents.setInstallSource, parameters: values)
    }
    
    func sendCloseInstallSource() {
        let values = getBaseEventValues()
        
        Analytics.logEvent(CustomEvents.closeInstallSource, parameters: values)
    }
    
    func sendOpenCommentsView(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        Analytics.logEvent(CustomEvents.openCommentsView, parameters: values)
    }
    
    func sendOpenWriteCommentView(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        Analytics.logEvent(CustomEvents.openWriteCommentView, parameters: values)
    }
    
    func sendSubmitWriteComment(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        Analytics.logEvent(CustomEvents.submitComment, parameters: values)
    }
    
    func sendCancelSubmitWriteComment(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        Analytics.logEvent(CustomEvents.submitComment, parameters: values)
    }
    
    func sendStartPrepFromButton() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.startPrepFromButton, parameters: values)
    }
    
    func sendStartPrepFromImage() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.startPrepFromImage, parameters: values)
    }
    
    func sendStartPrepSkipped() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.startPrepSkipped, parameters: values)
    }
    
    
    func sendPrepSessionBGSound(isPlaying: Bool) {
        var values = getBaseEventValues()
        values["isPlaying"] = isPlaying
        
        Analytics.logEvent(CustomEvents.prepSessionBgSound, parameters: values)
    }
    
    func sendPrepSessionSkipped(sessionId: String, sessionName: String, time: Int) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        values["time"] = time
        
        Analytics.logEvent(CustomEvents.prepSessionSkipped, parameters: values)
    }
    
    func sendPrepSessionProgressChangeAttempts() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.prepSessionProgressTaped, parameters: values)
    }
    
    func sendPrepSessionFinished(sessionId: String, sessionName: String, time: Int) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        values["time"] = time
        
        Analytics.logEvent(CustomEvents.prepSessionFinished, parameters: values)
    }
    
    
    func sendFeelingsMainSelected(feelingId: String, feelingName: String) {
        var values = getBaseEventValues()
        values["feelingId"] = feelingId
        values["feelingName"] = feelingName
        
        Analytics.logEvent(CustomEvents.feelingsMainSelected, parameters: values)
    }
    
    func sendFeelingsIntencitySelcted(subfeelingId: String, subfeelingName: String) {
        var values = getBaseEventValues()
        values["subfeelingId"] = subfeelingId
        values["subfeelingName"] = subfeelingName
        
        Analytics.logEvent(CustomEvents.feelingsIntencitySelcted, parameters: values)
    }
    
    func sendFeelingsLogged(feelingId: String, feelingName: String, subfeelingId: String, subfeelingName: String) {
        var values = getBaseEventValues()
        values["feelingId"] = feelingId
        values["feelingName"] = feelingName
        values["subfeelingId"] = subfeelingId
        values["subfeelingName"] = subfeelingName
        
        Analytics.logEvent(CustomEvents.feelingsLogged, parameters: values)
    }
    
    func sendFeelingsSkipped() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.feelingsSkipped, parameters: values)
    }
    
    func sendReminderDayTapped(dayId: String, dayName: String, selected: Bool) {
        var values = getBaseEventValues()
        values["dayId"] = dayId
        values["dayName"] = dayName
        values["selected"] = selected
        
        Analytics.logEvent(CustomEvents.reminderDayTapped, parameters: values)
    }
    
    func sendReminderTimeSelected(time: String) {
        var values = getBaseEventValues()
        values["time"] = time
        
        Analytics.logEvent(CustomEvents.reminderTimeSelected, parameters: values)
    }
    
    func sendReminderSet(dayId: String, dayName: String, time: String) {
        var values = getBaseEventValues()
        values["dayId"] = dayId
        values["dayName"] = dayName
        values["time"] = time
        
        Analytics.logEvent(CustomEvents.reminderSet, parameters: values)
    }
    
    func sendReminderSkipped() {
        let values = getBaseEventValues()
        Analytics.logEvent(CustomEvents.reminderSkipped, parameters: values)
    }
    
    private func getBaseEventValues() -> [String : Any] {
        return ["campaignId": UserDefaults.originalCampaignId() ?? "",
                "currentCampaignId": UserDefaults.currentCampaignId() ?? "",
                "is_premium" : UserDefaults.isPremium()]
    }
}
