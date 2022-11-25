//
//  TodayService.swift
//  Tawazon
//
//  Created by mac on 21/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation

protocol TodayService {
    func fetchTodaySections(completion: @escaping (_ sections: TodaySectionsModel?, _ error: CustomError?) -> Void)
    
    func getFeelingSessions(completion: @escaping (_ section: FeelingsSessions?, _ error: CustomError?) -> Void)
    
    func getFeelings(completion: @escaping (_ section: FeelingsListModel?, _ error: CustomError?) -> Void)
    
    func updateFeelings(feelingIds: [String], completion: @escaping (_ error: CustomError?) -> Void)
    
    func setQuoteViewed(quoteId: String, completion: @escaping (_ error: CustomError?) -> Void)
    
//    func getSectionSessions(sectionId: String, type: SectionData.SectionType, page: Int, pageSize: Int, completion: @escaping (_ section: SectionSessions?, _ error: CustomError?) -> Void)
    
//    func trackSessionDidEnd(sessionId: String, duration: TimeInterval, completion: @escaping (_ error: CustomError?) -> Void)
}

class TodayServiceFactory {
    
    static func service() -> TodayService {
        return APITodayService()
    }
}

class APITodayService: TodayService {

    
    func fetchTodaySections(completion: @escaping (_ sections: TodaySectionsModel?, _ error: CustomError?) -> Void) {
        ConnectionUtils.performGetRequest(url: Api.todaySectionsUrl.url!, parameters: nil) { (data, error) in
            
            var model: TodaySectionsModel?
            if let data = data {
                model = TodaySectionsModel(data: data)
            }
            completion(model, error)
        }
    }
    
    func getFeelingSessions(completion: @escaping (_ section: FeelingsSessions?, _ error: CustomError?) -> Void) {
        ConnectionUtils.performGetRequest(url: Api.feelingsSessions.url!, parameters: nil) { (data, error) in
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
    
    func setQuoteViewed(quoteId: String, completion: @escaping (_ error: CustomError?) -> Void){
        let url = Api.todayQuoteViewUrl.replacingOccurrences(of: "{id}", with: quoteId)
        ConnectionUtils.performGetRequest(url: url.url!, parameters: nil) { (data, error) in
            completion(error)
        }
    }
    
//    func getSectionSessions(sectionId: String, type: SectionData.SectionType, page: Int, pageSize: Int, completion: @escaping (_ section: SectionSessions?, _ error: CustomError?) -> Void) {
//        var urlString = Api.sectionSessionsV2_1.replacingOccurrences(of: "{id}", with: sectionId)
//        urlString = "\(urlString)?page=\(page)&limit=\(pageSize)"
//        if type == .subCategory {
//            urlString = Api.subCategorySectionSessionsListUrl.replacingOccurrences(of: "{categoryID}", with: sectionId)
//        }
//        ConnectionUtils.performGetRequest(url: urlString.url!, parameters: nil) { (data, error) in
//            var model: SectionSessions?
//            if let data = data {
//                model = SectionSessions(data: data)
//            }
//            completion(model, error)
//        }
//    }
    
//    func trackSessionDidEnd(sessionId: String, duration: TimeInterval, completion: @escaping (_ error: CustomError?) -> Void) {
//        let parameters = ["sessionId": sessionId, "duration": duration] as [String : Any]
//        ConnectionUtils.performPostRequest(url: Api.trackSessionUrl.url!, parameters: parameters) { (data, error) in
//            completion(error)
//        }
//    }

}


