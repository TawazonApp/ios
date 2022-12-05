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
        static let startSubscription = "purchase_process_success"
        static let unsbscribeTapped = "tap_unsubscribe"
        static let tapCancelSubscription = "cancel_payment_process"
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
        static let openPremium = "open_premium_view"
        static let closePremium = "close_premium_view"
        static let skipPremium = "af_skip_premium"
        static let tapProduct = "tap_product"
        static let startPaymentProcess = "start_payment_process"
        static let FailToPurchase = "purchase_process_fail"
        static let notificationStatusChanged = "af_notification_status_changed"
        static let openSupport = "af_open_support"
        static let openOurStory = "af_open_our_story"
        static let openPrivacyPolicy = "af_open_privacy_policy"
        static let openTermsOfUse = "af_open_terms_of_use"
        static let successlogout = "af_success_logout"
        static let cancellogout = "af_cancel_logout"
        static let rateApp = "af_rate_app"
        static let shareApp = "af_share_app"
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
        AppsFlyerLib.shared().customerUserID = userId
        AppsFlyerLib.shared().customData = ["is_premium": UserDefaults.isPremium()]
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
    
    func sendTapProductEvent(productId: String, name: String, price: Double) {
        var values = getBaseEventValues()
        values["id"] = productId
        values["name"] = name
        values["price"] = price
        
        AppsFlyerLib.shared().logEvent(CustomEvents.tapProduct, withValues: values)
    }
    
    func sendStartPaymentProcessEvent(productId: String, name: String, price: Double) {
        var values = getBaseEventValues()
        values["id"] = productId
        values["name"] = name
        values["price"] = price
        
        AppsFlyerLib.shared().logEvent(CustomEvents.startPaymentProcess, withValues: values)
    }
    
    func sendUnsbscribeButtonTappedEvent(productId: String, name: String) {
        var values = getBaseEventValues()
        values["id"] = productId
        values["name"] = name
        
        AppsFlyerLib.shared().logEvent(CustomEvents.unsbscribeTapped, withValues: values)
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
    
    func sendOpenPremiumEvent(viewName: String) {
        var values = getBaseEventValues()
        values["premiumViewName"] = viewName
        AppsFlyerLib.shared().logEvent(CustomEvents.openPremium,
                                             withValues: values)
    }
    
    func sendClosePremiumEvent(viewName: String) {
        var values = getBaseEventValues()
        values["premiumViewName"] = viewName
        
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
    
    func sendSessionListenForPeriodEvent(period: Double, sessionId: String) {
        var values = getBaseEventValues()
        values["period"] = period
        values["id"] = sessionId
        AppsFlyerLib.shared().logEvent(CustomEvents.sessionListenForPreiod, withValues: values)
    }
    
    func sendOpenSearchEvent() {
        let values = getBaseEventValues()
        AppsFlyerLib.shared().logEvent(CustomEvents.openSearch, withValues: values)
    }
    
    func sendSearchFor(query: String) {
        var values = getBaseEventValues()
        values["query"] = query
        AppsFlyerLib.shared().logEvent(CustomEvents.searchFor, withValues: values)
    }
    
    func sendTapPlaySessionFromSearchResultEvent(id: String, name: String) {
        var values = getBaseEventValues()
        values["name"] = name
        values["id"] = id
        AppsFlyerLib.shared().logEvent(CustomEvents.playSessionFromSearch, withValues: values)
    }
    
    func sendFailToPurchaseEvent(productId: String, plan: String, message: String) {
        var values = getBaseEventValues()
        values[AFEventParamContentId] = productId
        values["plan"] = plan
        values["message"] = message
        AppsFlyerLib.shared().logEvent(CustomEvents.FailToPurchase, withValues: values)
    }
    
    func sendOpenVoicesAndDialectsEvent() {
        let values = getBaseEventValues()
        AppsFlyerLib.shared().logEvent(CustomEvents.openVoicesAndDialects, withValues: values)
    }
    
    func sendChangeVoicesAndDialectsEvent(voice: String, dialect: String){
        var values = getBaseEventValues()
        values["voice"] = voice
        values["dialect"] = dialect
        AppsFlyerLib.shared().logEvent(CustomEvents.changeVoicesAndDialects, withValues: values)
    }
    
    func sendOpenSeries(id: String) {
        var values = getBaseEventValues()
        values["seriesId"] = id
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openSeries, withValues: values)
    }
    
    func sendGuidedTourStarted(viewName: String) {
        var values = getBaseEventValues()
        values["viewName"] = viewName
        
        AppsFlyerLib.shared().logEvent(CustomEvents.startGuidedTour, withValues: values)
    }
    
    func sendGuidedTourClosed(isAllSteps: Bool, viewName: String, stepTitle: String, stepNumber: Int) {
        var values = getBaseEventValues()
        values["viewName"] = viewName
        values["isFinishedAllSteps"] = isAllSteps
        values["stepTitle"] = stepTitle
        values["stepNumber"] = stepNumber
        
        AppsFlyerLib.shared().logEvent(CustomEvents.closeGuidedTour, withValues: values)
    }
    
    func sendGuidedTourRestarted() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.restartGuidedTour, withValues: values)
    }
    
    func sendSetAppLanguage(language: String) {
        var values = getBaseEventValues()
        values["language"] = language
        values["deviceLanguage"] = NSLocale.current.languageCode
        
        AppsFlyerLib.shared().logEvent(CustomEvents.setAppLang, withValues: values)
    }
    
    func sendSetInstallSource(installSource: String) {
        var values = getBaseEventValues()
        values["installSource"] = installSource
        
        AppsFlyerLib.shared().logEvent(CustomEvents.setInstallSource, withValues: values)
    }
    
    func sendOpenCommentsView(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openCommentsView, withValues: values)
    }
    
    func sendOpenWriteCommentView(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        AppsFlyerLib.shared().logEvent(CustomEvents.openWriteCommentView, withValues: values)
    }
    
    func sendSubmitWriteComment(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        AppsFlyerLib.shared().logEvent(CustomEvents.submitComment, withValues: values)
    }
    
    func sendCancelSubmitWriteComment(sessionId: String, sessionName: String) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        
        AppsFlyerLib.shared().logEvent(CustomEvents.submitComment, withValues: values)
    }
    
    func sendCloseInstallSource() {
        let values = getBaseEventValues()
        
        AppsFlyerLib.shared().logEvent(CustomEvents.closeInstallSource, withValues: values)
    }
    
    func sendStartPrepFromButton() {
        let values = getBaseEventValues()
        AppsFlyerLib.shared().logEvent(CustomEvents.startPrepFromButton, withValues: values)
    }
    
    func sendStartPrepFromImage() {
        let values = getBaseEventValues()
        AppsFlyerLib.shared().logEvent(CustomEvents.startPrepFromImage, withValues: values)
    }
    
    func sendStartPrepSkipped() {
        let values = getBaseEventValues()
        AppsFlyerLib.shared().logEvent(CustomEvents.startPrepSkipped, withValues: values)
    }
    
    func sendPrepSessionBGSound(isPlaying: Bool) {
        var values = getBaseEventValues()
        values["isPlaying"] = isPlaying
        
        AppsFlyerLib.shared().logEvent(CustomEvents.prepSessionBgSound, withValues: values)
    }
    
    func sendPrepSessionSkipped(sessionId: String, sessionName: String, time: Int) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        values["time"] = time
        
        AppsFlyerLib.shared().logEvent(CustomEvents.prepSessionSkipped, withValues: values)
    }
    
    func sendPrepSessionProgressChangeAttempts() {
        let values = getBaseEventValues()
        AppsFlyerLib.shared().logEvent(CustomEvents.prepSessionProgressTaped, withValues: values)
    }
    
    func sendPrepSessionFinished(sessionId: String, sessionName: String, time: Int) {
        var values = getBaseEventValues()
        values["sessionId"] = sessionId
        values["sessionName"] = sessionName
        values["time"] = time
        
        AppsFlyerLib.shared().logEvent(CustomEvents.prepSessionFinished, withValues: values)
    }
    
    func sendFeelingsMainSelected(feelingId: String, feelingName: String) {
        var values = getBaseEventValues()
        values["feelingId"] = feelingId
        values["feelingName"] = feelingName
        
        AppsFlyerLib.shared().logEvent(CustomEvents.feelingsMainSelected, withValues: values)
    }
    
    func sendFeelingsIntencitySelcted(subfeelingId: String, subfeelingName: String) {
        var values = getBaseEventValues()
        values["subfeelingId"] = subfeelingId
        values["subfeelingName"] = subfeelingName
        
        AppsFlyerLib.shared().logEvent(CustomEvents.feelingsIntencitySelcted, withValues: values)
    }
    
    func sendFeelingsLogged(feelingId: String, feelingName: String, subfeelingId: String, subfeelingName: String) {
        var values = getBaseEventValues()
        values["feelingId"] = feelingId
        values["feelingName"] = feelingName
        values["subfeelingId"] = subfeelingId
        values["subfeelingName"] = subfeelingName
        
        AppsFlyerLib.shared().logEvent(CustomEvents.feelingsLogged, withValues: values)
    }
    
    func sendFeelingsSkipped() {
        let values = getBaseEventValues()
        AppsFlyerLib.shared().logEvent(CustomEvents.feelingsSkipped, withValues: values)
    }
    
    func sendReminderDayTapped(dayId: String, dayName: String, selected: Bool) {
        var values = getBaseEventValues()
        values["dayId"] = dayId
        values["dayName"] = dayName
        values["selected"] = selected
        
        AppsFlyerLib.shared().logEvent(CustomEvents.reminderDayTapped, withValues: values)
    }
    
    func sendReminderTimeSelected(time: String) {
        var values = getBaseEventValues()
        values["time"] = time
        
        AppsFlyerLib.shared().logEvent(CustomEvents.reminderTimeSelected, withValues: values)
    }
    
    func sendReminderSet(dayId: String, dayName: String, time: String) {
        var values = getBaseEventValues()
        values["dayId"] = dayId
        values["dayName"] = dayName
        values["time"] = time
        
        AppsFlyerLib.shared().logEvent(CustomEvents.reminderSet, withValues: values)
    }
    
    func sendReminderSkipped() {
        let values = getBaseEventValues()
        AppsFlyerLib.shared().logEvent(CustomEvents.reminderSkipped, withValues: values)
    }
    
    func sendEvent(name: String, payload: [String:Any]?) {
        var values = getBaseEventValues()
        if let payload = payload{
            values.merge(payload){ (current, _) in current }
        }
        AppsFlyerLib.shared().logEvent(name, withValues: values)
    }
    
    private func getBaseEventValues() -> [AnyHashable : Any] {
        return ["idfa": UIApplication.identifierForAdvertising ?? "",
                "campaignId": UserDefaults.originalCampaignId() ?? "",
                "currentCampaignId": UserDefaults.currentCampaignId() ?? "",
                "is_premium" : UserDefaults.isPremium(),
                "userSegmentName" : RemoteConfigManager.shared.json(forKey: .first_dailyActivityFeatureFlow)["userSegmentName"] as? String ?? ""]
    }
}
