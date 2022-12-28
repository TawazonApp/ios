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
    func getTawazonTalkView(id: String, completion: @escaping(_ model: TawazonTalkModel? ,_ error: CustomError?)-> Void)
    
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
    func getTawazonTalkView(id: String, completion: @escaping(_ model: TawazonTalkModel? ,_ error: CustomError?)-> Void) {
        let url = Api.tawazonTalkViewUrl.replacingOccurrences(of: "{id}", with: id)
        ConnectionUtils.performGetRequest(url: url.url!, parameters: nil){(data, error) in
            var tawazonTalkModel: TawazonTalkModel?
            if let data = data{
                tawazonTalkModel = TawazonTalkModel(data: data)
            }
            completion(tawazonTalkModel, error)
        }
    }
}


