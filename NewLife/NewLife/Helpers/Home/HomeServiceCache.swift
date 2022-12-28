//
//  HomeCache.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

class HomeServiceCache: HomeService {
    
    
   
    var service: HomeService
        
    static let shared = HomeServiceCache()
    private var feelingSessions: FeelingsSessions?
    private var feelings: FeelingsListModel?
    private var lastCachedData: (date: Date, userId: String)?
    private var cacheInterval: TimeInterval = 60 * 60 * 4
    
    init() {
        self.service = HomeServiceFactory.service()
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged(_:)), name: .languageChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func languageChanged(_ sender: Notification) {
        resetCache()
    }
    
    func fetchHomeSections(completion: @escaping (_ sections: HomeSectionsModel?, _ error: CustomError?) -> Void) {
        service.fetchHomeSections(completion: completion)
    }
    
    func getFeelingSessions(completion: @escaping (_ section: FeelingsSessions?, _ error: CustomError?) -> Void) {
        if !isValidCacheData() {
            resetCache()
        }
        if let feelingSessions = self.feelingSessions {
            completion(feelingSessions, nil)
            return
        }
        service.getFeelingSessions { [weak self] (feelings, error) in
            if error == nil {
                if let userId = UserInfoManager.shared.getUserInfo()?.id {
                    self?.feelingSessions = feelings
                    self?.lastCachedData = (date: Date(), userId: userId)
                }
            }
            completion(feelings, error)
        }
    }
    
    func getFeelings(completion: @escaping (_ section: FeelingsListModel?, _ error: CustomError?) -> Void) {
        if !isValidCacheData() {
            resetCache()
        }
        if let feelings = self.feelings {
            completion(feelings, nil)
            return
        }
        service.getFeelings { [weak self] (feelings, error) in
            if error == nil {
                if let userId = UserInfoManager.shared.getUserInfo()?.id {
                    self?.feelings = feelings
                    self?.lastCachedData = (date: Date(), userId: userId)
                }
            }
            completion(feelings, error)
        }
    }
    
    func updateFeelings(feelingIds: [String], completion: @escaping (_ error: CustomError?) -> Void) {
        service.updateFeelings(feelingIds: feelingIds) { [weak self] (error) in
            if error == nil {
                self?.resetCache()
            }
            completion(error)
        }
    }
    
    func getSectionSessions(sectionId: String, type: SectionData.SectionType, page: Int, pageSize: Int, completion: @escaping (_ section: SectionSessions?, _ error: CustomError?) -> Void) {
        service.getSectionSessions(sectionId: sectionId,type: type, page: page, pageSize: pageSize, completion: completion)
    }
    
    func trackSessionDidEnd(sessionId: String, duration: TimeInterval, completion: @escaping (_ error: CustomError?) -> Void) {
        service.trackSessionDidEnd(sessionId: sessionId, duration: duration, completion: completion)
    }
    
    func submitNewFeatureInteract(featureId: String, completion: @escaping (CustomError?) -> Void) {
        service.submitNewFeatureInteract(featureId: featureId, completion: completion)
    }
    func resetCache() {
        lastCachedData = nil
        feelingSessions = nil
        feelings = nil
    }
    
    private func isValidCacheData() -> Bool {
        let todayString = getTodayString(fromDate: Date())
        let userId = UserInfoManager.shared.getUserInfo()?.id ?? ""
        guard let lastCachedData = self.lastCachedData else {
            return false
        }
        return lastCachedData.userId == userId &&
            getTodayString(fromDate: lastCachedData.date) == todayString &&
            Date().timeIntervalSince(lastCachedData.date) <= cacheInterval
    }
    
    private func getTodayString(fromDate date: Date) -> String {
       return DateFormatter.todayDate.string(from: date)
    }
}
