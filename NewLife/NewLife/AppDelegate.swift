//
//  AppDelegate.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import Fabric
import Crashlytics
import Firebase
import UserNotifications
import FirebaseMessaging
import SwiftyStoreKit
import AppsFlyerLib
import AudioToolbox
import UXCam

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: NavigationController?
    var notificationData: NotificationData?
    var paymentTransactions: [PaymentTransaction] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        
        initializeUXCam()
        initializeFirebase()
        initializeFabric()
        initializeAppsFlayer()
        initializeFacebook(application, didFinishLaunchingWithOptions: launchOptions)
        initialViewContoller()
        setupIAP()
        sendCampaignIds()
        DispatchQueue.main.async { [weak self] in
            self?.setupAudioPlayerManager()
        }
       
        UserInfoManager.shared.registerAppsflyer()
        initializeRemoteConfig()
        return true
    }
    func initializeRemoteConfig(){
        _ = RemoteConfigManager.shared
    }
    func resetApp() {
        UserInfoManager.shared.restCache()
        initialViewContoller()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
        BackgroundAudioManager.shared.playPauseBackgroundSounds()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if AudioPlayerManager.shared.isPlaying() && event?.subtype == UIEvent.EventSubtype.remoteControlPause {
            BackgroundAudioManager.shared.remoteControlReceivedWithEvent(event)
        }
        AudioPlayerManager.shared.remoteControlReceivedWithEvent(event)
        if AudioPlayerManager.shared.isPlaying() {
            BackgroundAudioManager.shared.remoteControlReceivedWithEvent(event)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        _ = application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: "")
        AppsFlyerLib.shared().handleOpen(url, options: options)
        
        _ = ApplicationDelegate.shared.application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            if let url = dynamicLink.url {
                handleDynamicLink(dynamicLink: url)
            }
        }
        
        
        AppsFlyerLib.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        
        _ = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamicLink, error) in
            if let url = dynamicLink?.url {
                self.handleDynamicLink(dynamicLink: url)
            }
        }
        
        return handled
    }
   
    private func initializeUXCam(){
        UXCam.optIntoSchematicRecordings()
        UXCam.start(withKey:"am0notpy21t31es")
    }
    private func initializeFabric() {
        Fabric.with([Crashlytics.self])
    }
    
    private func initializeFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    private func initializeFacebook(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        Settings.setAdvertiserTrackingEnabled(true)
        Settings.isAutoLogAppEventsEnabled = true
        Settings.isAdvertiserIDCollectionEnabled = true
    }
    
    private func initializeAppsFlayer() {
        AppsFlyerLib.shared().appsFlyerDevKey = Constants.appsFlyerDevKey
        AppsFlyerLib.shared().appleAppID = APPInfo.appId
        AppsFlyerLib.shared().delegate = self
       NotificationCenter.default.addObserver(self,
       selector: #selector(sendLaunch),
       name: UIApplication.didBecomeActiveNotification,
       object: nil)
    }
    
    
    @objc func sendLaunch(app:Any) {
        AppsFlyerLib.shared().start()
    }
    
    func registerRemoteNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        
        UIApplication.shared.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func setupAudioPlayerManager() {
        AudioPlayerManager.detailedLog = false
        AudioPlayerManager.verbose = false
        AudioPlayerManager.shared.setup()
    }
    
    private func initialViewContoller() {
        preFetchCachingData()
        let launchViewController = LaunchViewController.instantiate()
        navigationController = NavigationController.init(rootViewController: launchViewController)
        
        if UIApplication.shared.keyWindow == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.makeKeyAndVisible()
        }
        self.window?.rootViewController = navigationController
    }
    
    func pushWindowToRootViewController(viewController: UIViewController, animated: Bool) {
        
        if UIApplication.shared.keyWindow == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.makeKeyAndVisible()
        }
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        navigationController = NavigationController.init(rootViewController: viewController)
        window.setRootViewController(navigationController!, options: .init(direction: .toLeft, style: .easeOutQuart))
    }
    
    func switchRootViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        if UIApplication.shared.keyWindow == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.makeKeyAndVisible()
        }
        
        guard let window = UIApplication.shared.keyWindow else { return }
        navigationController = NavigationController.init(rootViewController: viewController)
        window.setRootViewController(navigationController!, options: .init(direction: .fade, style: .easeOutQuart))
    }
    
    
    private func preFetchCachingData() {
        ProfileVM(service: MembershipServiceFactory.service()).userInfo { (error) in }
        
        UserInfoManager.shared.getSubscriptionsTypes(service: MembershipServiceFactory.service()) { (_, _) in
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NewLife")
        let description = NSPersistentStoreDescription()
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () -> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            return ((try? context.save()) != nil) ? true : false
        }
        return false
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        handleNotification(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handleNotification(userInfo: userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        AppsFlyerLib.shared().registerUninstall(deviceToken)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //let userInfo = notification.request.content.userInfo
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func handleNotification(userInfo: [AnyHashable: Any]) {
        guard let action = userInfo["action"] as? String else {
            return
        }
        
        if let info = userInfo["info"] as? String {
            var notificationData: NotificationData? = nil
            let appStatus: NotificationAppStatus =  (UIApplication.shared.applicationState == .active) ? .foreground : .background
            if action == NotificationType.playSession.rawValue {
                if let session = SessionModel(info, using: String.Encoding.utf8) {
                    notificationData = NotificationData(type: NotificationType.playSession, data: session, appStatus: appStatus)
                }
            } else if action == NotificationType.category.rawValue {
                if let category = CategoryModel(info, using: String.Encoding.utf8) {
                    notificationData = NotificationData(type: NotificationType.playSession, data: category, appStatus: appStatus)
                }
            }
            
            (UIApplication.shared.delegate as? AppDelegate)?.notificationData = notificationData
            NotificationCenter.default.post(name: NSNotification.Name.didReceiveRemoteNotification, object: nil)
        }
    }
    
    func handleDynamicLink(dynamicLink: URL) {
        var notificationData: NotificationData? = nil
        let components = URLComponents(url: dynamicLink, resolvingAgainstBaseURL: false)
        
        let appStatus: NotificationAppStatus =  (UIApplication.shared.applicationState == .active) ? .foreground : .background
        let itemId = dynamicLink.lastPathComponent
        if let campaignId = components?.queryItems?.first(where: { $0.name == "campaignId" })?.value{
            UserDefaults.saveTempCampaigns(id: campaignId)
            NotificationCenter.default.post(name: NSNotification.Name.didReceiveDeeplink, object: nil)
        }
        // open section
        if dynamicLink.path.contains(DynamicLinkPath.section.rawValue) {
            notificationData = NotificationData(type: NotificationType.section, data: itemId, appStatus: appStatus)
        }
        else if dynamicLink.path.contains(DynamicLinkPath.session.rawValue) {
            notificationData = NotificationData(type: NotificationType.playSession, data: itemId, appStatus: appStatus)
        }
        else if dynamicLink.path.contains(DynamicLinkPath.category.rawValue) {
            if let categoryId = MainTabBarView.tabBarItemsIds.getItemId(forCategory: itemId) {
                notificationData = NotificationData(type: NotificationType.category, data: categoryId.rawValue, appStatus: appStatus)
            }else{
                notificationData = NotificationData(type: NotificationType.subCategory, data: itemId, appStatus: appStatus)
            }
            
        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.notificationData = notificationData
        NotificationCenter.default.post(name: NSNotification.Name.didReceiveRemoteNotification, object: nil)
        
        
    }
    private func sendCampaignIds(){
        if !UserDefaults.getTempCampaigns().isEmpty {
            TrackerManager.shared.sendOpenDynamiclinkEvent()
        }
        
    }
}


extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        sendFcmToken()
    }
    
    func sendFcmToken() {
        guard let fcmToken = Messaging.messaging().fcmToken else { return }
        FCMVM(service: MembershipServiceFactory.service()).sendFcmToken(fcmToken: fcmToken)
    }
}

extension AppDelegate {
    
    private func setupIAP() {
        paymentTransactions.removeAll()
        SwiftyStoreKit.completeTransactions(atomically: false) { [weak self] purchases in
           
            for purchase in purchases {
                
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                   // if purchase.needsFinishTransaction {
                        self?.uploadPurchaseReceipt(price: "", currancy: "", completion: { (error) in
                            if error == nil {
                                self?.finishTransaction(paymentTransaction: purchase.transaction)
                            } else {
                                self?.paymentTransactions.append(purchase.transaction)
                            }
                        })
                        
                   // }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
    }
    
    func uploadPurchaseReceipt(price: String, currancy: String, completion: @escaping (CustomError?) -> Void) {
        UserInfoManager.shared.uploadPurchaseReceipt(service: MembershipServiceFactory.service(), price: price, currency: currancy, completion: { (error) in
            if error == nil {
                for transaction in self.paymentTransactions {
                    self.finishTransaction(paymentTransaction: transaction)
                }
                self.paymentTransactions.removeAll()
            }
            completion(error)
        })
    }
    
    func finishTransaction(paymentTransaction: PaymentTransaction) {
        SwiftyStoreKit.finishTransaction(paymentTransaction)
    }
}


extension AppDelegate: AppsFlyerLibDelegate {
    
    //Handle Conversion Data (Deferred Deep Link)
     func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
     }
    
     func onConversionDataFail(_ error: Error) {
        print("\(error)")
     }
     
     //Handle Direct Deep Link
    func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
     }
     func onAppOpenAttributionFailure(_ error: Error) {
         print("\(error)")
     }
  
}
