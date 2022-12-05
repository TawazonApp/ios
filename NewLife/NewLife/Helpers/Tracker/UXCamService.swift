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
        UXCam.setUserIdentity(userId ?? "")
        UXCam.setUserProperty("idfa", value: UIApplication.identifierForAdvertising ?? "")
        UXCam.setUserProperty("is_premium", value: UserDefaults.isPremium())
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
    
    func sendOpenSearchEvent() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.openSearch, withProperties: values)
    }
    
    func sendSearchFor(query: String) {
        var values = getBaseEventValues()
        values["query"] = query
        UXCam.logEvent(CustomEvents.searchFor, withProperties: values)
    }
    
    func sendTapPlaySessionFromSearchResultEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["name"] = name
        values["id"] = id
        UXCam.logEvent(CustomEvents.playSessionFromSearch, withProperties: values)
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
    
    func sendChangeVoicesAndDialectsEvent(voice: String, dialect: String){
        var values = getBaseEventValues()
        values["voice"] = voice
        values["dialect"] = dialect
        UXCam.logEvent(CustomEvents.changeVoicesAndDialects, withProperties: values)
    }
    
    func sendOpenSeries(id: String) {
        var values = getBaseEventValues()
        values["seriesId"] = id
        
        UXCam.logEvent(CustomEvents.openSeries, withProperties: values)
    }
    
    func sendGuidedTourStarted(viewName: String) {
        var values = getBaseEventValues()
        values["viewName"] = viewName
        
        UXCam.logEvent(CustomEvents.startGuidedTour, withProperties: values)
    }
    
    func sendGuidedTourClosed(isAllSteps: Bool, viewName: String, stepTitle: String, stepNumber: Int) {
        var values = getBaseEventValues()
        values["viewName"] = viewName
        values["isFinishedAllSteps"] = isAllSteps
        values["stepTitle"] = stepTitle
        values["stepNumber"] = stepNumber
        
        UXCam.logEvent(CustomEvents.closeGuidedTour, withProperties: values)
    }
    
    func sendGuidedTourRestarted() {
        let values = getBaseEventValues()
        
        UXCam.logEvent(CustomEvents.restartGuidedTour, withProperties: values)
    }
    
    func sendSetAppLanguage(language: String) {
        var values = getBaseEventValues()
        values["language"] = language
        values["deviceLanguage"] = NSLocale.current.languageCode
        
        UXCam.logEvent(CustomEvents.setAppLang, withProperties: values)
    }
    
    func sendSetInstallSource(installSource: String) {
        var values = getBaseEventValues()
        values["installSource"] = installSource
        
        UXCam.logEvent(CustomEvents.setInstallSource, withProperties: values)
    }
    
    func sendCloseInstallSource() {
        let values = getBaseEventValues()
        
        UXCam.logEvent(CustomEvents.closeInstallSource, withProperties: values)
    }
    
    func sendOpenCommentsView(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        UXCam.logEvent(CustomEvents.openCommentsView, withProperties: values)
    }
    
    func sendOpenWriteCommentView(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        UXCam.logEvent(CustomEvents.openWriteCommentView, withProperties: values)
    }
    
    func sendSubmitWriteComment(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        UXCam.logEvent(CustomEvents.submitComment, withProperties: values)
    }
    
    func sendCancelSubmitWriteComment(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        UXCam.logEvent(CustomEvents.submitComment, withProperties: values)
    }
    
    func sendStartPrepFromButton() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.startPrepFromButton, withProperties: values)
    }
    
    func sendStartPrepFromImage() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.startPrepFromImage, withProperties: values)
    }
    
    func sendStartPrepSkipped() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.startPrepSkipped, withProperties: values)
    }
    
    func sendPrepSessionBGSound(isPlaying: Bool) {
        var values = getBaseEventValues()
        values["isPlaying"] = isPlaying
        
        UXCam.logEvent(CustomEvents.prepSessionBgSound, withProperties: values)
    }
    
    func sendPrepSessionSkipped(sessionId: String, sessionName: String, time: Int) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        values["time"] = time
        
        UXCam.logEvent(CustomEvents.prepSessionSkipped, withProperties: values)
    }
    
    func sendPrepSessionProgressChangeAttempts() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.prepSessionProgressTaped, withProperties: values)
    }
    
    func sendPrepSessionFinished(sessionId: String, sessionName: String, time: Int) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        values["time"] = time
        
        UXCam.logEvent(CustomEvents.prepSessionFinished, withProperties: values)
    }
    
    func sendFeelingsMainSelected(feelingId: String, feelingName: String) {
        var values = getBaseEventValues()
        values["feelingId"] = feelingId
        values["feelingName"] = feelingName
        
        UXCam.logEvent(CustomEvents.feelingsMainSelected, withProperties: values)
    }
    
    func sendFeelingsIntencitySelcted(subfeelingId: String, subfeelingName: String) {
        var values = getBaseEventValues()
        values["subfeelingId"] = subfeelingId
        values["subfeelingName"] = subfeelingName
        
        UXCam.logEvent(CustomEvents.feelingsIntencitySelcted, withProperties: values)
    }
    
    func sendFeelingsLogged(feelingId: String, feelingName: String, subfeelingId: String, subfeelingName: String) {
        var values = getBaseEventValues()
        values["feelingId"] = feelingId
        values["feelingName"] = feelingName
        values["subfeelingId"] = subfeelingId
        values["subfeelingName"] = subfeelingName
        
        UXCam.logEvent(CustomEvents.feelingsLogged, withProperties: values)
    }
    
    func sendFeelingsSkipped() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.feelingsSkipped, withProperties: values)
    }
    
    func sendReminderDayTapped(dayId: String, dayName: String, selected: Bool) {
        var values = getBaseEventValues()
        values["dayId"] = dayId
        values["dayName"] = dayName
        values["selected"] = selected
        
        UXCam.logEvent(CustomEvents.reminderDayTapped, withProperties: values)
    }
    
    func sendReminderTimeSelected(time: String) {
        var values = getBaseEventValues()
        values["time"] = time
        
        UXCam.logEvent(CustomEvents.reminderTimeSelected, withProperties: values)
    }
    
    func sendReminderSet(dayId: String, dayName: String, time: String) {
        var values = getBaseEventValues()
        values["dayId"] = dayId
        values["dayName"] = dayName
        values["time"] = time
        
        UXCam.logEvent(CustomEvents.reminderSet, withProperties: values)
    }
    
    func sendReminderSkipped() {
        let values = getBaseEventValues()
        UXCam.logEvent(CustomEvents.reminderSkipped, withProperties: values)
    }
    
    private func getBaseEventValues() -> [String : Any] {
        return ["campaignId": UserDefaults.originalCampaignId() ?? "",
                "currentCampaignId": UserDefaults.currentCampaignId() ?? "",
                "is_premium" : UserDefaults.isPremium(),
                "userSegmentName" : RemoteConfigManager.shared.json(forKey: .first_dailyActivityFeatureFlow)["userSegmentName"] as? String ?? ""]
    }
}
