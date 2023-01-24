//
//  RemoteConfigManager.swift
//  Tawazon
//
//  Created by mac on 15/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import FirebaseRemoteConfig

enum RCValueKeys: String {
    case premuimPageViewName
    case premuimOfBannerViewName
    case homeFeedPremuimPageViewName
    case profilePremuimPageViewName
    case sectionPremuimPageViewName
    case prepSessionId
    case meditationReminderString
    case dailyActivityLockNextStep
    case first_dailyActivityFeatureFlow
    case premuimPage6DarkTheme
    case showNotifyMeButton
}
enum premuimPageViewNameValues: String{
    case defaultView = "PremiumViewController"
    case premiumOne = "Premium1ViewController"
    case premiumFour = "Premium4ViewController"
    case premiumFive = "Premium5ViewController"
    case paywall = "PaywallViewController"
}

class RemoteConfigManager{
    static let shared = RemoteConfigManager()
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    
    
    private init() {
        loadDefaultValues()
        fetchRemoteConfigCloudValues()
    }
    
}
//MARK: fetch and load
extension RemoteConfigManager{
    func loadDefaultValues() {
      let appDefaults: [String: Any?] = [
        RCValueKeys.premuimPageViewName.rawValue: "PremiumViewController",
      ]
      
      RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func fetchRemoteConfigCloudValues() {
      //FIXME: remove on production
      activateDebugMode()

      RemoteConfig.remoteConfig().fetch { [weak self] _, error in
        if let error = error {
          
          // In a real app, you would probably want to call the loading
          // done callback anyway, and just proceed with the default values.
          // I won't do that here, so we can call attention
          // to the fact that Remote Config isn't loading.
          return
        }

        RemoteConfig.remoteConfig().activate { _, _ in
            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.premuimPageViewName.rawValue)
            .stringValue ?? "undefined"
            
            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.homeFeedPremuimPageViewName.rawValue)
              .stringValue ?? "undefined"
            
            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.profilePremuimPageViewName.rawValue)
              .stringValue ?? "undefined"
            
            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.sectionPremuimPageViewName.rawValue)
              .stringValue ?? "undefined"
            
            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.premuimOfBannerViewName.rawValue)
              .stringValue ?? "undefined"
            
            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.prepSessionId.rawValue)
              .stringValue ?? "undefined"
            
            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.meditationReminderString.rawValue)
              .jsonValue

            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.dailyActivityLockNextStep.rawValue)
                .boolValue
            
            _ = RemoteConfig.remoteConfig().configValue(forKey: RCValueKeys.first_dailyActivityFeatureFlow.rawValue)
                .jsonValue
            
            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.premuimPage6DarkTheme.rawValue)
                .boolValue
            
            _ = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.showNotifyMeButton.rawValue)
                .boolValue
            
          self?.fetchComplete = true
          DispatchQueue.main.async {
            self?.loadingDoneCallback?()
          }

        }
      }
    }
    
    func activateDebugMode() {
      let settings = RemoteConfigSettings()
      settings.minimumFetchInterval = 0
      RemoteConfig.remoteConfig().configSettings = settings
    }
}
//MARK: get values
extension RemoteConfigManager{
    
    func string(forKey key: RCValueKeys) -> String {
      RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
    }
    
    func json(forKey key: RCValueKeys) -> [String: Any] {
        RemoteConfig.remoteConfig()[key.rawValue].jsonValue as? [String : Any] ?? ["":""]
    }
    
    func bool(forKey key: RCValueKeys) -> Bool {
      RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
    
    func double(forKey key: RCValueKeys) -> Double {
      RemoteConfig.remoteConfig()[key.rawValue].numberValue.doubleValue
    }
    
    func color(forKey key: RCValueKeys) -> UIColor {
      let colorAsHexString = RemoteConfig.remoteConfig()[key.rawValue]
        .stringValue ?? "#FFFFFF"
        let convertedColor = UIColor(colorAsHexString)
      return convertedColor
    }
    

    

    
}
