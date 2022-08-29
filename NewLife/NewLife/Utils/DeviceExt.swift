//
//  ConnectionUtils.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation
import UIKit
import AdSupport

extension UIDevice {
    
    class var iOSVersion:String {
        return UIDevice.current.systemVersion
    }
    
    class var deviceID:String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    class var modelIdentifier:String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
}


extension UIApplication {
    
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for urlString in urls {
            guard let url = urlString.url else {
                return
            }
            if application.canOpenURL(url) {
                application.open(url, options: [:], completionHandler: nil)
                return
            }
        }
    }
    
    class func isUpdateAvailable(callback: @escaping (Bool, String)->Void) {
        let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        
        ConnectionUtils.performGetRequest(url: "https://itunes.apple.com/lookup?bundleId=\(bundleId)".url!, parameters: nil) { (data, error) in
            if let data = data{
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] , let results = json["results"] as? [[String: Any]], let versionStore = (results.first)?["version"]  as? String, let versionSize = (results.first)?["fileSizeBytes"]  as? String{
                                let arrayStoreVersion = versionStore.split(separator: ".").compactMap { Int($0) }
                                let arrayLocalVersion = appVersion.split(separator: ".").compactMap { Int($0) }

                                if arrayLocalVersion.count != arrayStoreVersion.count {
                                  callback(true, versionSize) // different versioning system
                                  return
                                }

                                // check each segment of the version
                                for (localSegment, storeSegment) in zip(arrayLocalVersion, arrayStoreVersion) {
                                  if localSegment < storeSegment {
                                    callback(true, versionSize)
                                    return
                                  }
                                }
                              }
                              callback(false, "") // no new version or failed to fetch app store version
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
    }
    
    class var appName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }
    
    class var appVersion: String {
        return  Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    class var buildNumber:String {
        return  Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String
    }
    
    class var identifierForAdvertising: String? {
        // Check whether advertising tracking is enabled
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }
        // Get and return IDFA
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}

struct UserDefaultsKeys {
    static let userToken = "UserTokenKey"
    static let userSelectGoals = "UserSelectGoalsKey"
    static let userSelectedVoice = "UserSelectedVoiceKey"
    static let userSelectedDialect = "UserSelectedDialectKey"
    static let userAppBackgroundSound = "userAppBackgroundSound"
    static let userId = "UserIdKey"
    static let userPremium = "UserPremiumKey"
    static let ratedSessions = "ratedSessions"
    static let firstOpened = "AppFirstOpenedKey"
    static let discountOfferOpened = "DiscountOfferKey"
    static let originalCampaignId = "OriginalCampaignId"
    static let currentCampaignId = "CurrentCampaignId"
    static let tempCampigns = "TempCampaigns"
    static let firstGuided = "AppFirstGuidedKey"
}

extension UserDefaults {
    
    //User Token
    class func saveUserToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: UserDefaultsKeys.userToken)
        UserDefaults.standard.synchronize()
        UserInfoManager.shared.registerAppsflyer()
    }
    
    class func resetUserToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userToken)
        UserDefaults.standard.synchronize()
    }
    
    class func userToken() -> String? {
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.userToken) as? String
    }
    
    //User ID
    class func saveUser(user: UserInfoModel) {
        var userPremiumStatusChanged = false
        if userPremium()?.expireDate != user.premium?.expireDate {
            userPremiumStatusChanged = true
        }
        TrackerManager.shared.sendUserId(userId: user.id ?? "")
        UserDefaults.standard.set(user.id, forKey: UserDefaultsKeys.userId)
        if let premium = user.premium, let premiumString = premium.jsonString() {
            UserDefaults.standard.set(premiumString, forKey: UserDefaultsKeys.userPremium)
        } else {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userPremium)
        }
        UserDefaults.standard.synchronize()
        
        if userPremiumStatusChanged {
            NotificationCenter.default.post(name: NSNotification.Name.userPremiumStatusChanged, object: nil)
        }
    }
    
    class func resetUser() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userId)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userPremium)
        UserDefaults.standard.synchronize()
    }
    
    class func userId() -> String? {
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.userId) as? String
    }
    
    class func userPremium() -> UserPremiumModel? {
        if let userPremiumString = UserDefaults.standard.value(forKey: UserDefaultsKeys.userPremium) as? String {
            return UserPremiumModel(userPremiumString)
        }
        return nil
    }
    
    class func isPremium() -> Bool {
        return userPremium() != nil
    }
    
    class func isAnonymousUser() -> Bool{
        return (userId() == nil)
    }
    
    
    //User goals
    class func userSelectGoals() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.userSelectGoals)
        UserDefaults.standard.synchronize()
    }
    
    class func resetUserSelectGoals() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userSelectGoals)
        UserDefaults.standard.synchronize()
    }
    
    class func isUserSelectGoals() -> Bool {
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.userSelectGoals) as? Bool ?? false
    }
    
    class func sessionRated(sessionId: String) {
        var values = UserDefaults.standard.value(forKey: UserDefaultsKeys.ratedSessions) as? [String: Bool] ?? [String: Bool]()
        values[sessionId] = true
        UserDefaults.standard.set(values, forKey: UserDefaultsKeys.ratedSessions)
        UserDefaults.standard.synchronize()
    }
    
    class func isSessionRated(sessionId: String) -> Bool {
        let values = UserDefaults.standard.value(forKey: UserDefaultsKeys.ratedSessions) as? [String: Bool]
        return values?[sessionId] ?? false
    }
    
    class func isFirstOpened() -> Bool {
        let value = UserDefaults.standard.value(forKey: UserDefaultsKeys.firstOpened)
        return (value == nil)
    }
    
    class func appOpened() {
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.firstOpened)
    }
    
    class func isFirstDiscountOffer(id: String) -> Bool {
        let value = UserDefaults.standard.value(forKey: "Discount-\(id)")
        return (value == nil)
    }
    
    class func discountOfferOpened(id: String) {
        UserDefaults.standard.setValue(true, forKey: "Discount-\(id)")
    }
    //Voices and dialects
    //set
    class func saveSelectedVoice(code: String){
        UserDefaults.standard.setValue(code, forKey: UserDefaultsKeys.userSelectedVoice)
    }
    class func saveSelectedDialect(code: String){
        UserDefaults.standard.setValue(code, forKey: UserDefaultsKeys.userSelectedDialect)
    }
    //get
    class func selectedVoice() -> String?{
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.userSelectedVoice) as? String
    }
    class func selectedDialect() -> String?{
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.userSelectedDialect) as? String
    }
    //Background sound
    //set
    class func saveUserAppBackgroundSound(status: Bool){
        UserDefaults.standard.setValue(status, forKey: UserDefaultsKeys.userAppBackgroundSound)
    }
    //get
    class func userAppBackgroundSound() -> Bool?{
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.userAppBackgroundSound) as? Bool
    }
    //Campaigns
    class func saveOriginalCampaign(id: String){
        UserDefaults.standard.set(id, forKey: UserDefaultsKeys.originalCampaignId)
    }
    class func originalCampaignId() -> String? {
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.originalCampaignId) as? String
    }
    class func saveCurrentCampaign(id: String){
        UserDefaults.standard.set(id, forKey: UserDefaultsKeys.currentCampaignId)
    }
    class func currentCampaignId() -> String? {
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.currentCampaignId) as? String
    }
    class func saveTempCampaigns(id: String){
        var tempCampaigns = self.getTempCampaigns()
        let now = round(Date().timeIntervalSince1970)
        let param = ["name": "open_app", "campaign_id": id, "event_timestamp": now] as [String : Any]
        tempCampaigns.append(param)
        
        UserDefaults.standard.set(tempCampaigns, forKey: UserDefaultsKeys.tempCampigns)
    }
    class func getTempCampaigns() -> [[String : Any]]{
        return UserDefaults.standard.value(forKey: UserDefaultsKeys.tempCampigns) as? [[String : Any]] ?? []
    }
    class func resetTempCampaigns(){
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.tempCampigns)
        UserDefaults.standard.synchronize()
    }
}
