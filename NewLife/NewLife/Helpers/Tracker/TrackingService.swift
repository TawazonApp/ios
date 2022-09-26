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
}
