//
//  TrackerInterface.swift
//  Tawazon
//
//  Created by Shadi on 18/10/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

enum RegistrationMethod: String {
    case facebook = "Facebook"
    case email = "Email"
    case anonymous = "Anonymous"
}
enum GeneralCustomEvents {
    static let dailyActivityPrepSessionTapped = "dailyActivity_prepSession_tapped"
    static let dailyActivityPrepSessionClosed = "dailyActivity_prepSession_closed"
    static let dailyActivityPrepSessionFinished = "dailyActivity_prepSession_finished"
    static let dailyActivityFeelingsTapped = "dailyActivity_feelings_tapped"
    static let dailyActivityFeelingsMainSelected = "dailyActivity_feelings_mainSelected"
    static let dailyActivityFeelingsIntencitySelcted = "dailyActivity_feelings_intencitySelcted"
    static let dailyActivityFeelingsLogged = "dailyActivity_feelings_logged"
    static let dailyActivityFeelingsClosed = "dailyActivity_feelings_closed"
    static let dailyActivityFeelingSessionPlayed = "dailyActivity_feelingSessionPlayed"
    static let dailyActivityQuoteTapped = "dailyActivity_quoteTapped"
    static let feelingsLogged = "feelings_logged"
    static let newFeaturePopupClosed = "tawazonTalk_popup_close"
    static let newFeaturePopupAction = "tawazonTalk_popup_action"
    static let tawazonTalkOpened = "tawazonTalk_open_talk"
    static let tawazonTalkPlaySession = "tawazonTalk_PlaySession"
    static let subscribeToTalk = "subscribe_to_talk"
    static let itemShare = "item_share"
    static let TwFirstOpen = "tw_first_open"
    static let openLanguageScreen = "first_open_app_language"
    static let firstOpenSetAppLanguage = "first_open_set_app_language"
    
    static let openMembershipScreen = "membership_screen_load"
    static let membershipScreenSkip = "membership_screen_skip"
    static let membershipScreenRegistration = "membership_screen_registration"
    static let membershipScreenFacebook = "membership_screen_facebook"
    static let membershipScreenLogin = "membership_screen_login"
    static let membershipScreenPlatform = "membership_screen_platform"
    static let membershipScreenTerms = "membership_screen_terms"

    static let registrationScreenLoad = "registration_screen_load"
    static let registrationScreenBack = "registration_screen_back"
    static let registrationScreenSubmit = "registration_screen_submit"
    static let registrationScreenPlatform = "registration_screen_platform"
    static let registrationScreenFacebook = "registration_screen_facebook"
    static let registrationScreenLogin = "registration_screen_login"

    static let loginScreenLoad = "login_screen_load"
    static let loginScreenBack = "login_screen_back"
    static let loginScreenSubmit = "login_screen_submit"
    static let loginScreenForgetPassword = "login_screen_forget_password"
    static let loginScreenPlatform = "login_screen_platform"
    static let loginScreenFacebook = "login_screen_facebook"
    static let loginScreenRegistration = "login_screen_registration"

    static let forgetPasswordScreenLoad = "forget_password_screen_load"
    static let forgetPasswordScreenBack = "forget_password_screen_back"
    static let forgetPasswordScreenSubmit = "forget_password_screen_submit"

    static let resetPasswordScreenLoad = "reset_password_screen_load"
    static let resetPasswordScreenBack = "reset_password_screen_back"
    static let resetPasswordScreenSubmit = "reset_password_screen_submit"

    static let goalsScreenLoad = "goals_screen_load"
    static let goalsScreenSubmit = "goals_screen_submit"

    static let prepSessionScreenLoad = "prep_session_screen_load"
    static let prepSessionSkip = "prep_session_skip"
    static let prepSessionScreenPlayButton = "prep_session_screen_play_button"
    static let prepSessionScreenPlayImage = "prep_session_screen_play_image"

    static let prepSessionPlayerScreenLoad = "prep_session_player_screen_load"
    static let prepSessionPlayerScreenSkip = "prep_session_player_screen_skip"
    static let prepSessionPlayerScreenPlay = "prep_session_player_screen_play"
    static let prepSessionPlayerScreenBgMusic = "prep_session_player_screen_bg_music"

    static let landingFeelingsScreenLoad = "landing_feelings_screen_load"
    static let landingFeelingsScreenSkip = "landing_feelings_screen_skip"
    static let landingFeelingsScreenSubmit = "landing_feelings_screen_submit"

    static let landingReminderScreenLoad = "landing_reminder_screen_load"
    static let landingReminderSkip = "landing_reminder_skip"
    static let landingReminderSubmit = "landing_reminder_submit"

    static let homeScreenFirstOpen = "home_screen_first_open"
    static let homeScreenLoad = "home_screen_load"
    static let homeScreenBgMusic = "home_screen_bg_music"
    static let homeScreenMute = "home_screen_mute"

    static let dailyScreenLoad = "daily_screen_load"
    static let dailyScreenPrepSession = "daily_screen_prep_session"
    static let dailyScreenFeelings = "daily_screen_feelings"
    static let dailyScreenMoodTracker = "daily_screen_mood_tracker"
    static let dailyScreenQuote = "daily_screen_quote"
    static let dailyScreenTalk = "daily_screen_talk"

    static let dailyPrepSessionPlayerScreenLoad = "daily_prep_session_player_screen_load"
    static let dailyPrepSessionPlayerScreenSkip = "daily_prep_session_player_screen_skip"
    static let dailyPrepSessionPlayerScreenPlay = "daily_prep_session_player_screen_play"
    static let dailyPrepSessionPlayerScreenBgMusic = "daily_prep_session_player_screen_bg_music"

    static let dailyFeelingsScreenLoad = "daily_feelings_screen_load"
    static let dailyFeelingsScreenSkip = "daily_feelings_screen_skip"
    static let dailyFeelingsScreenSubmit = "daily_feelings_screen_submit"

    static let moodTrackerScreenLoad = "mood_tracker_screen_load"
    static let moodTrackerScreenSkip = "mood_tracker_screen_skip"
    static let moodTrackerScreenDate = "mood_tracker_screen_date"
    static let moodTrackerScreenDateType = "mood_tracker_screen_date_type"

    static let myAccountScreenLoad = "my_account_screen_load"
    static let myAccountScreenMoodTracker = "my_account_screen_mood_tracker"
    static let myAccountScreenPremium = "my_account_screen_premium"

    static let paywallScreenLoad = "paywall_screen_load"
    static let paywallScreenSkip = "paywall_screen_skip"
    static let paywallScreenDiscountCode = "paywall_screen_discount_code"
    static let paywallScreenSubmit = "paywall_screen_submit"
    static let paywallScreenAllPlans = "paywall_screen_all_plans"
    static let paywallScreenRestore = "paywall_screen_restore"
    static let paywallScreenTerms = "paywall_screen_terms"
    static let paywallScreenPolicy = "paywall_screen_policy"
    static let paywallScreenSuccessProcess = "paywall_screen_success_process"
    static let paywallScreenFailProcess = "paywall_screen_fail_process"
    static let paywallScreenCancelProcess = "paywall_screen_cancel_process"
    static let paywallScreenFailRestoreProcess = "paywall_screen_restore_fail_process"
    static let paywallScreenSuccessRestoreProcess = "paywall_screen_restore_success_process"

    static let paywallAllPlansScreenLoad = "paywall_all_plans_screen_load"
    static let paywallAllPlansScreenSkip = "paywall_all_plans_screen_skip"
    
    static let sessionPlayerScreenLoad = "session_player_screen_load"
    static let sessionPlayerScreenBgMusic = "session_player_screen_bg_music"
    static let sessionPlayerScreenHide = "session_player_screen_hide"
    static let sessionPlayerScreenDownload = "session_player_screen_download"
    static let sessionPlayerScreenFavorite = "session_player_screen_favorite"
    static let sessionPlayerScreenDetails = "session_player_screen_details"
    static let sessionPlayerScreenPlay = "session_player_screen_play"
    static let sessionPlayerScreenForward = "session_player_screen_farword"
    static let sessionPlayerScreenBackward = "session_player_screen_backward"
    static let sessionPlayerScreenDialects = "session_player_screen_dialects"
    static let sessionPlayerScreenComments = "session_player_screen_comments"
    static let sessionPlayerScreenRate = "session_player_screen_rate"
    static let sessionPlayerScreenShare = "session_player_screen_share"

    static let tawazonTalkScreenLoad = "tawazon_talk_screen_load"
    static let tawazonTalkScreenBack = "tawazon_talk_screen_back"
    static let tawazonTalkScreenShare = "tawazon_talk_screen_share"
    static let tawazonTalkScreenPlay = "tawazon_talk_screen_play"
    static let tawazonTalkScreenPlayItem = "tawazon_talk_screen_play_item"



}

protocol TrackingService {
    func sendUserId(userId: String?)
    func sendLoginEvent()
    func sendCompleteRegistrationEvent(method: RegistrationMethod)
    func sendStartSubscriptionEvent(productId: String, plan: PremiumPurchase?, price: Double, currency: String, trial: Bool)
    func sendTapCancelSubscriptionEvent(productId: String, plan: String)
    func sendSetGoalEvent(id: String, name: String)
    func sendTapCategoryEvent(id: String, name: String)
    func sendTapSubCategoryEvent(id: String, name: String)
    func sendPlaySoundEffectEvent(name: String)
    func sendPlaySessionEvent(id: String, name: String)
    func sendDownloadSessionEvent(id: String, name: String)
    func sendLikeSessionEvent(id: String, name: String)
    func sendOpenMoreEvent()
    func sendOpenUserProfileEvent()
    func sendUserChangeNameEvent()
    func sendUserChangePhotoEvent()
    func sendUserChangePasswordEvent()
    func sendOpenDownloadedLibraryEvent()
    func sendOpenSectionSessionList(sectionId: String, name: String)
    func sendOpenPremiumEvent(viewName: String)
    func sendClosePremiumEvent(viewName: String)
    func sendSkipPremiumEvent()
    func sendTapProductEvent(productId: String, name: String, price: Double)
    func sendStartPaymentProcessEvent(productId: String, name: String, price: Double)
    func sendUnsbscribeButtonTappedEvent(productId: String, name: String)
    func sendNotificationStatusChangedEvent(status: Bool)
    func sendOpenSupportEvent()
    func sendOpenOurStoryEvent()
    func sendOpenPrivacyPolicyEvent()
    func sendOpenTermsOfUseEvent()
    func sendSuccesslogoutEvent()
    func sendCancelLogoutEvent()
    func sendRateAppEvent()
    func sendShareAppEvent()
    func sendSessionListenForPeriodEvent(period: Double, sessionId: String)
    func sendFailToPurchaseEvent(productId: String, plan: String, message: String)
    func sendOpenVoicesAndDialectsEvent()
    func sendChangeVoicesAndDialectsEvent(voice: String, dialect: String)
    func sendOpenSearchEvent()
    func sendSearchFor(query: String)
    func sendTapPlaySessionFromSearchResultEvent(id: String, name: String)
    func sendOpenSeries(id: String)
    func sendGuidedTourStarted(viewName: String)
    func sendGuidedTourClosed(isAllSteps: Bool, viewName: String, stepTitle: String, stepNumber: Int)
    func sendGuidedTourRestarted()
    func sendSetAppLanguage(language: String)
    func sendSetInstallSource(installSource: String)
    func sendCloseInstallSource()
    func sendOpenCommentsView(sessionId: String, sessionName: String)
    func sendOpenWriteCommentView(sessionId: String, sessionName: String)
    func sendSubmitWriteComment(sessionId: String, sessionName: String)
    func sendCancelSubmitWriteComment(sessionId: String, sessionName: String)
    func sendStartPrepFromButton()
    func sendStartPrepFromImage()
    func sendStartPrepSkipped()
    func sendPrepSessionBGSound(isPlaying: Bool)
    func sendPrepSessionSkipped(sessionId: String, sessionName: String, time: Int)
    func sendPrepSessionProgressChangeAttempts()
    func sendPrepSessionFinished(sessionId: String, sessionName: String, time: Int)
    func sendFeelingsMainSelected(feelingId: String, feelingName: String)
    func sendFeelingsIntencitySelcted(subfeelingId: String, subfeelingName: String)
    func sendFeelingsLogged(feelingId: String, feelingName: String, subfeelingId: String, subfeelingName: String)
    func sendFeelingsSkipped()
    func sendReminderDayTapped(dayId: String, dayName: String, selected: Bool)
    func sendReminderTimeSelected(time: String)
    func sendReminderSet(dayId: String, dayName: String, time: String)
    func sendReminderSkipped()
    func sendEvent(name: String, payload: [String : Any]?)
}
