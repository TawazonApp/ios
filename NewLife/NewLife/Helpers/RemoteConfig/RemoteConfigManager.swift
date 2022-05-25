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
    case premuimPageViewName
    case homeFeedPremuimPageViewName
    case profilePremuimPageViewName
    case sectionPremuimPageViewName
}
enum premuimPageViewNameValues: String{
    case defaultView = "PremiumViewController"
    case premiumOne = "Premium1ViewController"
    case premiumFour = "Premium4ViewController"
    case premiumFive = "Premium5ViewController"
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
        print("loadDefaultValues")
      let appDefaults: [String: Any?] = [
        RCValueKeys.premuimPageViewName.rawValue: "PremiumViewController",
      ]
      
      RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
    }
    
    func fetchRemoteConfigCloudValues() {
        print("fetchRemoteConfigCloudValues")
      //FIXME: remove on production
      activateDebugMode()

      RemoteConfig.remoteConfig().fetch { [weak self] _, error in
        if let error = error {
          print("Uh-oh. Got an error fetching remote values \(error)")
          // In a real app, you would probably want to call the loading
          // done callback anyway, and just proceed with the default values.
          // I won't do that here, so we can call attention
          // to the fact that Remote Config isn't loading.
          return
        }

        RemoteConfig.remoteConfig().activate { _, _ in
            let appPrimaryPremiumViewName = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.premuimPageViewName.rawValue)
            .stringValue ?? "undefined"
            print("appPrimaryPremiumViewName: \(appPrimaryPremiumViewName), rawValue: \(RCValueKeys.premuimPageViewName.rawValue)")

            let homeFeedPremuimPageViewName = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.homeFeedPremuimPageViewName.rawValue)
              .stringValue ?? "undefined"
            print("homeFeedPremuimPageViewName: \(homeFeedPremuimPageViewName), rawValue: \(RCValueKeys.homeFeedPremuimPageViewName.rawValue)")

            let profilePremuimPageViewName = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.profilePremuimPageViewName.rawValue)
              .stringValue ?? "undefined"
            print("profilePremuimPageViewName: \(profilePremuimPageViewName), rawValue: \(RCValueKeys.profilePremuimPageViewName.rawValue)")

            let sectionPremuimPageViewName = RemoteConfig.remoteConfig()
                .configValue(forKey: RCValueKeys.sectionPremuimPageViewName.rawValue)
              .stringValue ?? "undefined"
            print("sectionPremuimPageViewName: \(sectionPremuimPageViewName), rawValue: \(RCValueKeys.sectionPremuimPageViewName.rawValue)")


            print("CONFIG: \(RemoteConfig.remoteConfig().allKeys(from: .remote))")
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
