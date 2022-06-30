//
//  TrackerManager.swift
//  Tawazon
//
//  Created by Shadi on 18/10/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class TrackerManager: TrackingService {
    
    
    static let shared = TrackerManager()
    let services: [TrackingService] = [AppsFlyerTrackingService(), FirebaseTrackingService(), UXCamTrackerService()]
    
    private init() {
    }
    
    func sendUserId(userId: String?) {
        for service in services {
            service.sendUserId(userId: userId)
        }
    }
    
    func sendStartSubscriptionEvent(productId: String, plan: PremiumPurchase?, price: Double, currency: String, trial: Bool) {
        for service in services {
            service.sendStartSubscriptionEvent(productId: productId, plan: plan, price: price, currency: currency, trial: trial)
        }
    }
    
    func sendTapProductEvent(productId: String, name: String, price: Double) {
        for service in services {
            service.sendTapProductEvent(productId: productId,name: name, price: price)
        }
    }
    
    func sendStartPaymentProcessEvent(productId: String, name: String, price: Double) {
        for service in services {
            service.sendStartPaymentProcessEvent(productId: productId,name: name, price: price)
        }
    }
    
    func sendUnsbscribeButtonTappedEvent(productId: String, name: String) {
        for service in services {
            service.sendUnsbscribeButtonTappedEvent(productId: productId,name: name)
        }
    }
    
    func sendTapCancelSubscriptionEvent(productId: String, plan: String) {
        for service in services {
            service.sendTapCancelSubscriptionEvent(productId: productId, plan: plan)
        }
    }
    
    func sendSetGoalEvent(id: String, name: String) {
        for service in services {
            service.sendSetGoalEvent(id: id, name: name)
        }
    }
    
    func sendTapCategoryEvent(id: String, name: String) {
        for service in services {
            service.sendTapCategoryEvent(id: id, name: name)
        }
    }
    
    func sendTapSubCategoryEvent(id: String, name: String) {
        for service in services {
            service.sendTapSubCategoryEvent(id: id, name: name)
        }
    }
    
    func sendPlaySoundEffectEvent(name: String) {
        for service in services {
             service.sendPlaySoundEffectEvent(name: name)
        }
    }
    
    func sendPlaySessionEvent(id: String, name: String) {
        for service in services {
             service.sendPlaySessionEvent(id: id, name: name)
        }
    }
    
    func sendDownloadSessionEvent(id: String, name: String) {
        for service in services {
             service.sendDownloadSessionEvent(id: id, name: name)
        }
    }
    
    func sendLikeSessionEvent(id: String, name: String) {
        for service in services {
             service.sendLikeSessionEvent(id: id, name: name)
        }
    }
    
    func sendOpenMoreEvent() {
        for service in services {
             service.sendOpenMoreEvent()
        }
    }
    
    func sendOpenUserProfileEvent() {
        for service in services {
             service.sendOpenUserProfileEvent()
        }
    }
    
    func sendUserChangeNameEvent() {
        for service in services {
             service.sendUserChangeNameEvent()
        }
    }
    
    func sendUserChangePhotoEvent() {
        for service in services {
             service.sendUserChangePhotoEvent()
        }
    }
    
    func sendUserChangePasswordEvent() {
        for service in services {
             service.sendUserChangePasswordEvent()
        }
    }
    
    func sendOpenDownloadedLibraryEvent() {
        for service in services {
             service.sendOpenDownloadedLibraryEvent()
        }
    }
    
    func sendOpenSectionSessionList(sectionId: String, name: String) {
        for service in services {
            service.sendOpenSectionSessionList(sectionId: sectionId, name: name)
        }
    }
    
    func sendOpenPremiumEvent(viewName: String) {
        for service in services {
             service.sendOpenPremiumEvent(viewName: viewName)
        }
    }
    
    func sendClosePremiumEvent(viewName: String) {
        for service in services {
            service.sendClosePremiumEvent(viewName: viewName)
        }
    }
    
    func sendSkipPremiumEvent() {
        for service in services {
            service.sendSkipPremiumEvent()
        }
    }
    func sendNotificationStatusChangedEvent(status: Bool) {
        for service in services {
             service.sendNotificationStatusChangedEvent(status: status)
        }
    }
    
    func sendOpenSupportEvent() {
        for service in services {
             service.sendOpenSupportEvent()
        }
    }
    
    func sendOpenOurStoryEvent() {
        for service in services {
             service.sendOpenOurStoryEvent()
        }
    }
    
    func sendOpenPrivacyPolicyEvent() {
        for service in services {
            service.sendOpenPrivacyPolicyEvent()
        }
    }
    
    func sendOpenTermsOfUseEvent() {
        for service in services {
             service.sendOpenTermsOfUseEvent()
        }
    }
    
    func sendSuccesslogoutEvent() {
        for service in services {
             service.sendSuccesslogoutEvent()
        }
    }
    
    func sendCancelLogoutEvent() {
        for service in services {
             service.sendCancelLogoutEvent()
        }
    }
    
    func sendRateAppEvent() {
        for service in services {
             service.sendRateAppEvent()
        }
    }
    
    func sendShareAppEvent() {
        for service in services {
             service.sendShareAppEvent()
        }
    }
    
    
    func sendSessionListenForPeriodEvent(period: Double, sessionId: String) {
        for service in services {
            service.sendSessionListenForPeriodEvent(period: period, sessionId: sessionId)
        }
    }
    
    func sendOpenSearchEvent() {
        for service in services {
             service.sendOpenSearchEvent()
        }
    }
    
    func sendSearchFor(query: String) {
        for service in services {
            service.sendSearchFor(query: query)
        }
    }
    
    func sendTapPlaySessionFromSearchResultEvent(id: String, name: String) {
        for service in services {
            service.sendTapPlaySessionFromSearchResultEvent(id: id, name: name)
        }
    }
    
    func sendFailToPurchaseEvent(productId: String, plan: String, message: String){
        for service in services {
            service.sendFailToPurchaseEvent(productId: productId, plan: plan, message: message)
        }
    }
    
    func sendLoginEvent() {
        for service in services {
            service.sendLoginEvent()
        }
    }
    
    func sendCompleteRegistrationEvent(method: RegistrationMethod) {
        for service in services {
            service.sendCompleteRegistrationEvent(method: method)
        }
    }
    
    func sendOpenVoicesAndDialectsEvent(){
        for service in services {
            service.sendOpenVoicesAndDialectsEvent()
        }
    }
    
    //MARK: Server Tracking
    func sendOpenDynamiclinkEvent() {
        let tempCampaigns = UserDefaults.getTempCampaigns()
        let param = ["items": tempCampaigns] as [String : Any]
        ConnectionUtils.performPostRequest(url: Api.trackingUrl.url!, parameters: param) { (data, error) in
            
            var campaign: CampaignTrackingModel?
            if let data = data {
                campaign = CampaignTrackingModel(data: data)
                if campaign?.status ?? false{
                    UserDefaults.saveOriginalCampaign(id: campaign?.item.originalCampaignId ?? "")
                    UserDefaults.saveCurrentCampaign(id: campaign?.item.currentCampaignId ?? "")
                    UserDefaults.resetTempCampaigns()
                }
                
            }
        }
    }
}
