//
//  LifecycleManager.swift
//  Adapty
//
//  Created by Aleksey Goncharov on 27.10.2022.
//

import Foundation
import StoreKit

#if canImport(UIKit)
    import UIKit
#endif

class LifecycleManager {
    private static let underlayQueue = DispatchQueue(label: "Adapty.SDK.Lifecycle")
    private static let appOpenedSendInterval: TimeInterval = 60.0
    private static let profileUpdateInterval: TimeInterval = 60.0
    private static let profileUpdateShortInterval: TimeInterval = 10.0

    static let shared = LifecycleManager()
    static var purchaseInfoUpdateScheduled = false

    private var appOpenedSentAt: Date?
    private var profileSyncAt: Date?

    private var needsSyncStorefrontCountry = false
    private var initialized = false

    func initialize() {
        guard !initialized else { return }

        Log.info("LifecycleManager: initialize")

        subscribeForLifecycleEvents()
        scheduleProfileUpdate(after: Self.profileUpdateInterval)

        initialized = true
    }

    private func scheduleProfileUpdate(after delay: TimeInterval) {
        guard !Self.purchaseInfoUpdateScheduled else {
            Log.verbose("LifecycleManager: scheduleProfileUpdate already scheduled")
            return
        }

        Log.verbose("LifecycleManager: scheduleProfileUpdate after \(delay) sec.")

        Self.purchaseInfoUpdateScheduled = true

        Self.underlayQueue.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.syncProfile { [weak self] success in
                Self.purchaseInfoUpdateScheduled = false

                self?.scheduleProfileUpdate(after: success ? Self.profileUpdateInterval : Self.profileUpdateShortInterval)
            }
        }
    }

    private func subscribeForLifecycleEvents() {
        #if canImport(UIKit)
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                                   object: nil,
                                                   queue: nil) { [weak self] _ in
                Log.verbose("LifecycleManager: didBecomeActiveNotification")

                self?.sendAppOpenedEvent()
                self?.scheduleProfileUpdate(after: 0.0)
            }

            if #available(iOS 13.0, *) {
                NotificationCenter.default.addObserver(forName: Notification.Name.SKStorefrontCountryCodeDidChange,
                                                       object: nil,
                                                       queue: nil) { [weak self] _ in
                    Log.verbose("LifecycleManager: SKStorefrontCountryCodeDidChange")

                    self?.needsSyncStorefrontCountry = true
                }
            }
        #endif
    }

    @objc
    private func syncProfile(completion: @escaping (Bool) -> Void) {
        if let profileSyncAt = profileSyncAt,
           Date().timeIntervalSince(profileSyncAt) < Self.profileUpdateInterval {
            completion(false)
            return
        }

        Log.verbose("LifecycleManager: syncProfile Begin")

        if needsSyncStorefrontCountry, let storeCountry = Environment.Device.storeCountry {
            Adapty.updateProfile(params: AdaptyProfileParameters(storeCountry: storeCountry)) { [weak self] error in
                if let error = error {
                    Log.verbose("LifecycleManager: syncProfile Error: \(error)")
                    completion(false)
                } else {
                    Log.verbose("LifecycleManager: syncProfile Done")

                    self?.needsSyncStorefrontCountry = false
                    self?.profileSyncAt = Date()
                    completion(true)
                }
            }
        } else {
            Adapty.getProfile { [weak self] result in
                switch result {
                case .success:
                    Log.verbose("LifecycleManager: syncProfile Done")
                    self?.profileSyncAt = Date()
                    completion(true)
                case let .failure(error):
                    Log.verbose("LifecycleManager: syncProfile Error: \(error)")
                    completion(false)
                }
            }
        }
    }

    private func sendAppOpenedEvent() {
        if let appOpenedSentAt = appOpenedSentAt, Date().timeIntervalSince(appOpenedSentAt) < Self.appOpenedSendInterval {
            Log.verbose("LifecycleManager: sendAppOpenedEvent too early")
            return
        }

        Log.verbose("LifecycleManager: sendAppOpenedEvent Begin")

        Adapty.logAppOpened { [weak self] error in
            if case let .encoding(_, error) = error?.originalError as? EventsError {
                Log.error("LifecycleManager: sendAppOpenedEvent Error: \(error)")
            } else if let error = error {
                Log.verbose("LifecycleManager: sendAppOpenedEvent Error: \(error)")
            } else {
                Log.verbose("LifecycleManager: sendAppOpenedEvent Done")
                self?.appOpenedSentAt = Date()
            }
        }
    }
}
