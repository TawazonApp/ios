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
