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
    
    func sendChangeVoicesAndDialectsEvent(voice: String, dialect: String){
        for service in services {
            service.sendChangeVoicesAndDialectsEvent(voice: voice, dialect: dialect)
        }
    }
    
    func sendOpenSeries(id: String) {
        for service in services {
            service.sendOpenSeries(id: id)
        }
    }
    
    func sendGuidedTourStarted(viewName: String) {
        for service in services {
            service.sendGuidedTourStarted(viewName: viewName)
        }
    }
    
    func sendGuidedTourClosed(isAllSteps: Bool, viewName: String, stepTitle: String, stepNumber: Int)  {
        for service in services {
            service.sendGuidedTourClosed(isAllSteps: isAllSteps, viewName: viewName, stepTitle: stepTitle, stepNumber: stepNumber)
        }
    }
    func sendGuidedTourRestarted(){
        for service in services {
            service.sendGuidedTourRestarted()
        }
    }
    
    func sendSetAppLanguage(language: String) {
        for service in services {
            service.sendSetAppLanguage(language: language)
        }
    }
    
    func sendSetInstallSource(installSource: String) {
        for service in services {
            service.sendSetInstallSource(installSource: installSource)
        }
    }
    
    func sendCloseInstallSource() {
        for service in services {
            service.sendCloseInstallSource()
        }
    }
    func sendOpenCommentsView(sessionId: String, sessionName: String) {
        for service in services {
            service.sendOpenCommentsView(sessionId: sessionId, sessionName: sessionName)
        }
    }
    
    func sendOpenWriteCommentView(sessionId: String, sessionName: String) {
        for service in services {
            service.sendOpenWriteCommentView(sessionId: sessionId, sessionName: sessionName)
        }
    }
    
    func sendSubmitWriteComment(sessionId: String, sessionName: String) {
        for service in services {
            service.sendSubmitWriteComment(sessionId: sessionId, sessionName: sessionName)
        }
    }
    
    func sendCancelSubmitWriteComment(sessionId: String, sessionName: String) {
        for service in services {
            service.sendCancelSubmitWriteComment(sessionId: sessionId, sessionName: sessionName)
        }
    }
    
    func sendStartPrepFromButton() {
        for service in services {
            service.sendStartPrepFromButton()
        }
    }
    
    func sendStartPrepFromImage() {
        for service in services {
            service.sendStartPrepFromImage()
        }
    }
    
    func sendStartPrepSkipped() {
        for service in services {
            service.sendStartPrepSkipped()
        }
    }
    func sendPrepSessionBGSound(isPlaying: Bool){
        for service in services {
            service.sendPrepSessionBGSound(isPlaying: isPlaying)
        }
    }
    func sendPrepSessionSkipped(sessionId: String, sessionName: String, time: Int){
        for service in services {
            service.sendPrepSessionSkipped(sessionId: sessionId, sessionName: sessionName, time: time)
        }
    }
    func sendPrepSessionProgressChangeAttempts(){
        for service in services {
            service.sendPrepSessionProgressChangeAttempts()
        }
    }
    func sendPrepSessionFinished(sessionId: String, sessionName: String, time: Int){
        for service in services {
            service.sendPrepSessionFinished(sessionId: sessionId, sessionName: sessionName, time: time)
        }
    }
    
    func sendFeelingsMainSelected(feelingId: String, feelingName: String){
        for service in services {
            service.sendFeelingsMainSelected(feelingId: feelingId, feelingName: feelingName)
        }
    }
    func sendFeelingsIntencitySelcted(subfeelingId: String, subfeelingName: String){
        for service in services {
            service.sendFeelingsIntencitySelcted(subfeelingId: subfeelingId, subfeelingName: subfeelingName)
        }
    }
    func sendFeelingsLogged(feelingId: String, feelingName: String, subfeelingId: String, subfeelingName: String){
        for service in services {
            service.sendFeelingsLogged(feelingId: feelingId, feelingName: feelingName, subfeelingId: subfeelingId, subfeelingName: subfeelingName)
        }
    }
    func sendFeelingsSkipped(){
        for service in services {
            service.sendFeelingsSkipped()
        }
    }
    
    func sendReminderDayTapped(dayId: String, dayName: String, selected: Bool){
        for service in services {
            service.sendReminderDayTapped(dayId: dayId, dayName: dayName, selected:selected)
        }
    }
    func sendReminderTimeSelected(time: String){
        for service in services {
            service.sendReminderTimeSelected(time:time)
        }
    }
    func sendReminderSet(dayId: String, dayName: String, time: String){
        for service in services {
            service.sendReminderSet(dayId: dayId, dayName: dayName, time:time)
        }
    }
    func sendReminderSkipped(){
        for service in services {
            service.sendReminderSkipped()
        }
    }
    
    func sendEvent(name: String, payload: [String: Any]?){
        for service in services {
            service.sendEvent(name: name, payload: payload)
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
