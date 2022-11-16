//
//  UserInfoManager.swift
//  NewLife
//
//  Created by Shadi on 11/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import AppsFlyerLib

class UserInfoManager: NSObject {
    
    static let shared = UserInfoManager()
    private override init() {}
    
    private var userInfo: UserInfoModel?
    private var goals: GoalsModel?
    private (set) var profileImageUploading: UIImage?
    private (set) var subscription: (types: SubscriptionTypes, date: Date)?
    
    func setUserInfo(userInfo: UserInfoModel?) {
        self.userInfo = userInfo
        if let userInfo = userInfo {
            UserDefaults.saveUser(user: userInfo)
        }
    }
    
    func setUserSettings(){
        let sessionVoiceCode = userInfo?.settings?.defaultAudioSource?.components(separatedBy: ".").first ?? ""
        let sessionDialectCode = userInfo?.settings?.defaultAudioSource ?? ""
        
        UserDefaults.saveSelectedVoice(code: sessionVoiceCode)
        UserDefaults.saveSelectedDialect(code: sessionDialectCode)
    }
    
    func getUserInfo() -> UserInfoModel? {
        return userInfo
    }
    
    func setGoals(goals: GoalsModel?) {
        self.goals = goals
        if goals != nil {
            if (goals!.goals?.filter({$0.isSelected() == true}).count) ?? 0 > 0  {
                UserDefaults.userSelectGoals()
            }
        }
    }
    
    func getGoals() -> GoalsModel? {
        return goals
    }
    
    func reset() {
        setUserInfo(userInfo: nil)
        setGoals(goals: nil)
        UserDefaults.resetUserSelectGoals()
        UserDefaults.resetUser()
    }
    
    func restCache() {
        subscription = nil
    }
    
    func uploadProfileImage(service: MembershipService, image: UIImage, completion: @escaping (_ error: CustomError?) -> Void) {
        
        guard profileImageUploading == nil else {
            completion(CustomError(message: "profileImageStillUploadingErrorMessage".localized, statusCode: nil))
            return
        }
        
        profileImageUploading = image
        service.uploadProfileImage(image: image) { [weak self] (error) in
            if error == nil {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self?.fetchUserInfo(service: service, completion: { (fetchError) in
                        self?.profileImageUploading = nil
                        completion(error)
                    })
                })
            } else {
                self?.profileImageUploading = nil
                completion(error)
            }
            
        }
    }
    
    func removeProfileImage(service: MembershipService, completion: @escaping (_ error: CustomError?) -> Void) {
        service.removeProfileImage() { [weak self] (error) in
            if error == nil {
                self?.fetchUserInfo(service: service, completion: { (fetchError) in
                    completion(error)
                })
            } else {
                completion(error)
            }
        }
    }
    
    func fetchUserInfo(service: MembershipService, completion: @escaping (_ error: CustomError?) -> Void) {
        service.fetchUserInfo(completion: { [weak self](userInfo, error) in
            if error == nil {
                self?.setUserInfo(userInfo: userInfo)
            }
            completion(error)
        })
    }
   
    func uploadPurchaseReceipt(service: MembershipService, price: String, currency: String, completion: @escaping (CustomError?) -> Void) {
        guard let receiptData = SwiftyStoreKit.localReceiptData else {
            return
        }
        registerAppsflyer()
        let receiptString = receiptData.base64EncodedString(options: [])
        
        service.uploadPurchaseReceipt(receiptString: receiptString, price: price, currency: currency) { [weak self] (error) in
            if error == nil {
                //TO make sure user info updated afte upload receipt
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self?.fetchUserInfo(service: service, completion: { (fetchError) in
                        completion(error)
                    })
                })
            } else {
                completion(error)
            }
        }
    }
    
    func registerAppsflyer() {
        guard UserDefaults.userToken() != nil else {
            return
        }
        let service =  MembershipServiceFactory.service()
        let advertisingId = AppsFlyerLib.shared().advertisingIdentifier
        let appsflyerId = AppsFlyerLib.shared().getAppsFlyerUID()
        service.registerAppsflyer(id: appsflyerId, advertisingId: advertisingId) { (error) in
        }
    }
    
    func submitPromoCode(service: MembershipService, promoCode: String, completion: @escaping (CustomError?) -> Void) {
        service.submitPromoCode(promoCode: promoCode, completion: completion)
    }
    
    func getSubscriptionsTypes(service: MembershipService, completion: @escaping (SubscriptionTypes?, CustomError?) -> Void) {
        if let subscription = self.subscription {
            let cacheInterval = Date().timeIntervalSince(subscription.date)
            if cacheInterval < 5 * 60 && cacheInterval >= 0 {
                completion(self.subscription?.types, nil)
                return
            }
        }
        
        service.getSubscriptionsTypes() { [weak self] (types, error) in
            if let types = types {
                self?.subscription = (types: types, date: Date())
            }
            completion(types, error)
        }
    }
    
    func setUserSessionSettings(settings: UserSettings,service: MembershipService, completion: @escaping (_ error: CustomError?) -> Void) {
        service.setUserSessionSettings(settings: settings, completion: { (error) in
            if error == nil {
                if let defaultAudioSource = settings.defaultAudioSource{
                    UserDefaults.saveSelectedVoice(code:(defaultAudioSource.components(separatedBy: "."))[0])
                    UserDefaults.saveSelectedDialect(code: defaultAudioSource)
                }
            }
            completion(error)
        })
    }
}
