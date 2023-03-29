//
//  FirebaseTrackerManager.swift
//  Tawazon
//
//  Created by Shadi on 18/10/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import Firebase

enum CustomEvents {
    static let startSubscription = "purchase_process_success" // when a user successfully subscribed
    static let unsbscribeTapped = "tap_unsubscribe" // unsubscribe button tapped
    static let tapCancelSubscription = "cancel_payment_process" // when a user cancel subscribtion process
    static let setGoal = "set_goal" // user's selected goals
    static let tapCategory = "tap_category" // not used any more
    static let tapSubCategory = "tap_sub_category" // NU
    static let playSoundEffect = "play_sound_effect" // taping sound effects
    static let playSession = "play_session" // on start playing session
    static let downloadSession = "download_session" // on download session locally
    static let likeSession = "like_session" // on adding session to favorites
    static let sessionListenForPreiod = "session_listen_for_period" // on listening
    static let openMore = "open_more" // on open my account screen
    static let openUserProfile = "open_user_profile" // on open user profile screen
    static let userChangeName = "user_change_name" // on change user name
    static let userChangePhoto = "user_change_photo" // on change user photo
    static let userChangePassword = "user_change_password" // on change password
    static let openDownloadedLibrary = "open_downloaded_library" // on open downloads
    static let openSectionSessionList = "af_section_session_list"
    static let openPremium = "open_premium_view" // on open premium screen
    static let closePremium = "close_premium_view" // on tap close premium view
    static let skipPremium = "skip_premium" // on tap close premium view button that appeared before home view
    static let tapProduct = "tap_product" // on user plan selection in old premium and premium 4
    static let startPaymentProcess = "start_payment_process" // called on payment queue
    static let FailToPurchase = "purchase_process_fail" // on fail purchase process
    static let notificationStatusChanged = "notification_status_changed" // on toggle notification switch in moreVC
    static let openSupport = "open_support" // on tap support button in moreVC
    static let openOurStory = "open_our_story" // on tap our story button in moreVC
    static let openPrivacyPolicy = "open_privacy_policy" // on load privacy policy screen
    static let openTermsOfUse = "open_terms_of_use" // on load terms and conditions view
    static let successlogout = "success_logout" // on logout successfully
    static let cancellogout = "cancel_logout" // on cancel logout
    static let rateApp = "rate_app" // on tap rate button in our story screen
    static let shareApp = "share_app" // on tap share button in our story screen
    static let openVoicesAndDialects = "open_voices_and_dialects" // on load voices and dialects
    static let changeVoicesAndDialects = "change_voices_and_dialects" // on change voices and dialects
    static let openSearch = "open_search_view" // on load search screen
    static let searchFor = "search_for" // on write search text
    static let playSessionFromSearch = "play_session_from_search" // on play session from search screen
    static let openSeries = "open_series" // on load series screen
    static let startGuidedTour = "guided_tour_started"
    static let closeGuidedTour = "guided_tour_closed"
    static let restartGuidedTour = "tap_restart_tutorial"
    static let setAppLang = "set_app_language" // NU
    static let setInstallSource = "set_install_source"
    static let closeInstallSource = "close_install_source"
    static let openCommentsView = "open_comments_view" // on load comments screen
    static let openWriteCommentView = "open_write_comment_view" // on load write comments screen
    static let submitComment = "submit_comment" // on submit comment
    static let cancelSubmitComment = "cancel_submit_comment" // on tap cancel write comment
    static let startPrepFromButton = "startPrep_fromButton" // on tap play prep session from prep session screen
    static let startPrepFromImage = "startPrep_fromImage" // on tap image prep session from prep session screen
    static let startPrepSkipped = "startPrep_skipped" // on tap (x) button from prep session screen
    static let prepSessionBgSound = "prepSession_bgSound" // on tap bg music button from prep session player screen
    static let prepSessionSkipped = "prepSession_skipped" // on tap (x) button from prep session player screen
    static let prepSessionProgressTaped = "prepSession_progressTaped" // on tap progress tracker of prep session player
    static let prepSessionFinished = "prepSession_finished" // on finish prep session
    static let feelingsMainSelected = "feelings_mainSelected" // on select feeling
    static let feelingsIntencitySelcted = "feelings_intencitySelcted" // on change feeling intensity
    static let feelingsLogged = "feelings_logged" // on submit feeling
    static let feelingsSkipped = "feelings_skipped" // on tap (x) button in feeling screen
    static let reminderDayTapped = "reminder_dayTapped" // on tap day in reminder screen
    static let reminderTimeSelected = "reminder_timeSelected" // on tap time in reminder screen
    static let reminderSet = "reminder_set"// on submit button tapped in reminder screen
    static let reminderSkipped = "reminder_skipped"// on (x) button tapped in reminder screen
}

class FirebaseTrackingService: TrackingService {
    
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
    
    func sendEvent(name: String, payload: [String:Any]?) {
        var values = getBaseEventValues()
        if let payload = payload{
            values.merge(payload){ (current, _) in current }
        }
        Analytics.logEvent(name, parameters: values)
    }
    
    private func getBaseEventValues() -> [String : Any] {
        return ["campaignId": UserDefaults.originalCampaignId() ?? "",
                "currentCampaignId": UserDefaults.currentCampaignId() ?? "",
                "is_premium" : UserDefaults.isPremium(),
                "userSegmentName" : RemoteConfigManager.shared.json(forKey: .first_dailyActivityFeatureFlow)["userSegmentName"] as? String ?? ""]
    }
}
