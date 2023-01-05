//
//  HomeSessionService.swift
//  NewLife
//
//  Created by Shadi on 14/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

protocol HomeService {
    func fetchHomeSections(completion: @escaping (_ sections: HomeSectionsModel?, _ error: CustomError?) -> Void)
    
    func getFeelingSessions(completion: @escaping (_ section: FeelingsSessions?, _ error: CustomError?) -> Void)
    
    func getFeelings(completion: @escaping (_ section: FeelingsListModel?, _ error: CustomError?) -> Void)
    
    func updateFeelings(feelingIds: [String], completion: @escaping (_ error: CustomError?) -> Void)
    
    func getSectionSessions(sectionId: String, type: SectionData.SectionType, page: Int, pageSize: Int, completion: @escaping (_ section: SectionSessions?, _ error: CustomError?) -> Void)
    
    func trackSessionDidEnd(sessionId: String, duration: TimeInterval, completion: @escaping (_ error: CustomError?) -> Void)
    
    func submitNewFeatureInteract(featureId: String, completion: @escaping(_ error: CustomError?) -> Void)
}

class HomeServiceFactory {
    
    static func service() -> HomeService {
        return APIHomeService()
    }
}

class APIHomeService: HomeService {

    
    func fetchHomeSections(completion: @escaping (_ sections: HomeSectionsModel?, _ error: CustomError?) -> Void) {
        ConnectionUtils.performGetRequest(url: Api.homeSectionsWithBannersUrlV2_3.url!, parameters: nil) { (data, error) in
            
            var model: HomeSectionsModel?
            if let data = data {
                model = HomeSectionsModel(data: data)
            }
            completion(model, error)
        }
    }
    
    func getFeelingSessions(completion: @escaping (_ section: FeelingsSessions?, _ error: CustomError?) -> Void) {
        ConnectionUtils.performGetRequest(url: Api.feelingsSessionsV2_3.url!, parameters: nil) { (data, error) in
            var model: FeelingsSessions?
            if let data = data {
                model = FeelingsSessions(data: data)
            }
            completion(model, error)
        }
    }
    
    func getFeelings(completion: @escaping (_ section: FeelingsListModel?, _ error: CustomError?) -> Void) {
        ConnectionUtils.performGetRequest(url: Api.feelingsListUrl.url!, parameters: nil) { (data, error) in
            var model: FeelingsListModel?
            if let data = data {
                model = FeelingsListModel(data: data)
            }
            completion(model, error)
        }
    }
    
    func updateFeelings(feelingIds: [String], completion: @escaping (_ error: CustomError?) -> Void) {
        let parameters = ["feelings": feelingIds]
        ConnectionUtils.performPostRequest(url: Api.updateFeelings.url!, parameters: parameters) { (data, error) in
            completion(error)
        }
    }
    
    func getSectionSessions(sectionId: String, type: SectionData.SectionType, page: Int, pageSize: Int, completion: @escaping (_ section: SectionSessions?, _ error: CustomError?) -> Void) {
        var urlString = Api.sectionSessionsV2_3.replacingOccurrences(of: "{id}", with: sectionId)
        urlString = "\(urlString)?page=\(page)&limit=\(pageSize)"
        if type == .subCategory {
            urlString = Api.subCategorySectionSessionsListUrl.replacingOccurrences(of: "{categoryID}", with: sectionId)
        }
        ConnectionUtils.performGetRequest(url: urlString.url!, parameters: nil) { (data, error) in
            var model: SectionSessions?
            if let data = data {
                model = SectionSessions(data: data)
            }
            completion(model, error)
        }
    }
    
    func trackSessionDidEnd(sessionId: String, duration: TimeInterval, completion: @escaping (_ error: CustomError?) -> Void) {
        let parameters = ["sessionId": sessionId, "duration": duration] as [String : Any]
        ConnectionUtils.performPostRequest(url: Api.trackSessionUrl.url!, parameters: parameters) { (data, error) in
            completion(error)
        }
    }

    func submitNewFeatureInteract(featureId: String, completion: @escaping(_ error: CustomError?) -> Void){
        var url = Api.newFeatureInteract.replacingOccurrences(of: "{id}", with: featureId)
        ConnectionUtils.performGetRequest(url: url.url!, parameters: nil){ (data, error) in
            completion(error)
        }
    }
}


