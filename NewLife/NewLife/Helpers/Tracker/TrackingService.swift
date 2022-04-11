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
    func sendOpenPremiumEvent()
    func sendClosePremiumEvent()
    func sendSkipPremiumEvent()
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
    func sendFailToPurchaseEvent(message: String)
}
