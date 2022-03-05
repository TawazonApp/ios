//
//  SessionService.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

protocol SessionService {
    
    func downloadSessionFile(localFileUrl: URL, remoteUrl: URL, completion: @escaping (CustomError?) -> Void)
    
    func fetchCategoryData(categoryId: String, page: Int, pageSize:Int, completion: @escaping (CategoryModel?, CustomError?) -> Void)
    
    func fetchCategoryDetails(categoryId: String, page: Int, pageSize:Int, completion: @escaping (SuperCategoryModel?, CustomError?) -> Void)
    
    func fetchSubCategorySessions(subCategoryId: String, page: Int, pageSize: Int, completion: @escaping (SubCategoryModel?, CustomError?) -> Void)
    
    func fetchDownloadedSessions(page: Int, pageSize:Int, completion: @escaping (SessionsModel?, CustomError?) -> Void)
    
    func addToDownloadList(sessionId: String, completion: @escaping (CustomError?) -> Void)
    
    func removeFromDownloadList(sessionId: String, completion: @escaping (CustomError?) -> Void)
    
    func addToFavorites(favorites: SessionFavoritesModel, completion: @escaping (CustomError?) -> Void)
    
     func removeFromFavorites(favorites: SessionFavoritesModel, completion: @escaping (CustomError?) -> Void)
    
    func rateSession(sessionId: String, rate: Int, completion: @escaping (CustomError?) -> Void)
    
    func fetchSessionInfo(sessionId: String,completion: @escaping (SessionModel?, CustomError?) -> Void)
    
}

class SessionServiceFactory {
    
    static func service() -> SessionService {
        return APISessionService()
    }
}

class APISessionService: SessionService {
    
     func fetchCategoryData(categoryId: String, page: Int, pageSize:Int, completion: @escaping (CategoryModel?, CustomError?) -> Void) {
        
        let url = Api.categorySessionsListUrl.replacingOccurrences(of: "{id}", with: categoryId).url!
        
        ConnectionUtils.performGetRequest(url: url, parameters: ["page": page, "limit": pageSize]) { (data, error) in
            var categoryModel: CategoryModel?
            if let data = data {
                categoryModel = CategoryModel(data: data)
            }
            completion(categoryModel, error)
        }
    }
    
    func fetchCategoryDetails(categoryId: String, page: Int, pageSize:Int, completion: @escaping (SuperCategoryModel?, CustomError?) -> Void){
        
       let url = Api.categoryDetailsUrl.replacingOccurrences(of: "{id}", with: categoryId).url!
       ConnectionUtils.performGetRequest(url: url, parameters: ["page": page, "limit": pageSize]) { (data, error) in
           var superCategoryModel: SuperCategoryModel?
           if let data = data {
               superCategoryModel = SuperCategoryModel(data: data)
           }
           completion(superCategoryModel, error)
       }
   }
    
     func fetchSubCategorySessions(subCategoryId: String, page: Int, pageSize: Int, completion: @escaping (SubCategoryModel?, CustomError?) -> Void) {
        
        let url = Api.subCategorySessionsListUrl.replacingOccurrences(of: "{id}", with: subCategoryId).url!
        
        ConnectionUtils.performGetRequest(url: url, parameters: ["page": page, "limit": pageSize]) { (data, error) in
            var subCategoryModel: SubCategoryModel?
            if let data = data {
                subCategoryModel = SubCategoryModel(data: data)
            }
            completion(subCategoryModel, error)
        }
    }

    func fetchDownloadedSessions(page: Int, pageSize: Int, completion: @escaping (SessionsModel?, CustomError?) -> Void) {
        
        ConnectionUtils.performGetRequest(url: Api.sessionsDownloadListUrl.url!, parameters: ["page": page, "limit": pageSize]) { (data, error) in
            
            var sessionsModel: SessionsModel?
            if let data = data {
                sessionsModel = SessionsModel(data: data)
            }
            
            completion(sessionsModel, error)
        }
    }
    
    
    func downloadSessionFile(localFileUrl: URL, remoteUrl: URL, completion: @escaping (CustomError?) -> Void) {
        
        ConnectionUtils.downloadFile(remoteUrl: remoteUrl, localFileUrl: localFileUrl) { (error) in
            completion(error)
        }
    }
    
    func addToDownloadList(sessionId: String, completion: @escaping (CustomError?) -> Void) {
       
        let url = Api.addSessionToDownloadUrl.replacingOccurrences(of: "{id}", with: sessionId).url!
        ConnectionUtils.performPostRequest(url: url, parameters: nil) { (data, error) in
            completion(error)
        }
    }
    
    func removeFromDownloadList(sessionId: String, completion: @escaping (CustomError?) -> Void) {
       
        let url = Api.removeSessionToDownloadUrl.replacingOccurrences(of: "{id}", with: sessionId).url!
        ConnectionUtils.performPostRequest(url: url, parameters: nil) { (data, error) in
            completion(error)
        }
    }
    
    func addToFavorites(favorites: SessionFavoritesModel, completion: @escaping (CustomError?) -> Void) {
        
        ConnectionUtils.performPostRequest(url: Api.addToFavoritesUrl.url!, parameters: try? favorites.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
    func removeFromFavorites(favorites: SessionFavoritesModel, completion: @escaping (CustomError?) -> Void) {
        
        ConnectionUtils.performPostRequest(url: Api.removeFromFavoritesUrl.url!, parameters: try? favorites.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
    func rateSession(sessionId: String, rate: Int, completion: @escaping (CustomError?) -> Void) {
        let url = Api.rateSession.replacingOccurrences(of: "{id}", with: sessionId).url!
        let paramters = ["rate" : rate]
        ConnectionUtils.performPostRequest(url: url, parameters: paramters) { (data, error) in
            completion(error)
        }
    }
    
    func fetchSessionInfo(sessionId: String, completion: @escaping (SessionModel?, CustomError?) -> Void) {
        let url = Api.sessionInfo.replacingOccurrences(of: "{id}", with: sessionId).url!
        ConnectionUtils.performGetRequest(url: url, parameters: nil) { (data, error) in
            var sessionInfoModel: SessionInfoModel?
            if let data = data {
                sessionInfoModel = SessionInfoModel(data: data)
            }
            completion(sessionInfoModel?.session, error)
        }
    }

}
