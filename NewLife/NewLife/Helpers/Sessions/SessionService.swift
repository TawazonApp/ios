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
    
    func fetchSearchResults(page: Int, pageSize: Int, query: String?, completion: @escaping (SearchModel?, CustomError?) -> Void )
    
    func fetchDownloadedSessions(page: Int, pageSize:Int, completion: @escaping (SessionsModel?, CustomError?) -> Void)
    
    func fetchFavoriteSessions(page: Int, pageSize:Int, completion: @escaping (SessionFavoritesModel?, CustomError?) -> Void)
    
    func addToDownloadList(sessionId: String, completion: @escaping (CustomError?) -> Void)
    
    func removeFromDownloadList(sessionId: String, completion: @escaping (CustomError?) -> Void)
    
//    func addToFavorites(favorites: SessionFavoritesModel, completion: @escaping (CustomError?) -> Void)
    
    func addToFavorites(favorites: [String], completion: @escaping (CustomError?) -> Void)
    
    func removeFromFavorites(favorites: [String], completion: @escaping (CustomError?) -> Void)
    
    func rateSession(sessionId: String, rate: Int, completion: @escaping (CustomError?) -> Void)
    
    func fetchSessionInfo(sessionId: String,completion: @escaping (SessionModel?, CustomError?) -> Void)
    
    func setUserSessionSettings(settings: UserSettings, completion: @escaping (_ error: CustomError?) -> Void)
    
    func getSeriesSessions(seriesId: String, completion: @escaping (_ series: SeriesModel?, _ error: CustomError?) -> Void)
    
    func setSeriesSessionCompleted(seriesId: String, sessionId: String, duration: TimeInterval, completion: @escaping (_ error: CustomError?) -> Void)
    
    func getSessionComments(sessionId: String, completion: @escaping (CommentsModel?, CustomError?) -> Void)
    
    func addSessionComment(sessionId: String, content:String, rating: Int, completion: @escaping (_ error: CustomError?) -> Void)
    
    func updateSessionComment(commentId:String, content:String, rating: Int, completion: @escaping (_ error: CustomError?) -> Void)
}

class SessionServiceFactory {
    
    static func service() -> SessionService {
        return APISessionService()
    }
}

class APISessionService: SessionService {
    
    func fetchSearchResults(page: Int, pageSize: Int, query: String? = "", completion: @escaping (SearchModel?, CustomError?) -> Void) {
        
        let url = Api.searchSessionV2_1.replacingOccurrences(of: "{query}", with: query ?? "").url!
        let param = ["page": page, "limit": pageSize]
        ConnectionUtils.performGetRequest(url: url, parameters: param){
            (data, error) in
            var searchModel: SearchModel?
            if let data = data{
                searchModel = SearchModel(data: data)
            }
            completion(searchModel, error)
        }
    }
    
    
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
        
       let url = Api.categoryDetailsUrlV2_1.replacingOccurrences(of: "{id}", with: categoryId).url!
       ConnectionUtils.performGetRequest(url: url, parameters: ["page": page, "limit": pageSize]) { (data, error) in
           var superCategoryModel: SuperCategoryModel?
           if let data = data {
               superCategoryModel = SuperCategoryModel(data: data)
           }
           completion(superCategoryModel, error)
       }
   }
    
     func fetchSubCategorySessions(subCategoryId: String, page: Int, pageSize: Int, completion: @escaping (SubCategoryModel?, CustomError?) -> Void) {
        
        let url = Api.subCategorySessionsListUrlV2_1.replacingOccurrences(of: "{id}", with: subCategoryId).url!
        
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
    func fetchFavoriteSessions(page: Int, pageSize: Int, completion: @escaping (SessionFavoritesModel?, CustomError?) -> Void) {
        
        ConnectionUtils.performGetRequest(url: Api.sessionsFavoriteListUrlV2_1.url!, parameters: ["page": page, "limit": pageSize]) { (data, error) in

            var sessionFavoritesModel: SessionFavoritesModel?
            if let data = data {
                sessionFavoritesModel = SessionFavoritesModel(data: data)
            }

            completion(sessionFavoritesModel, error)
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
    
    func addToFavorites(favorites: [String], completion: @escaping (CustomError?) -> Void) {
        
        var favoriteIds: [String] = [String]()
        for sessionId in favorites {
            favoriteIds.append(sessionId)
        }
        
        let favoriteList = ["favorites": favoriteIds]
        
        ConnectionUtils.performPostRequest(url: Api.addToFavoritesUrlV2_1.url!, parameters: try? favoriteList.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
    func removeFromFavorites(favorites: [String], completion: @escaping (CustomError?) -> Void) {
        
        var favoriteIds: [String] = [String]()
        for sessionId in favorites {
            favoriteIds.append(sessionId)
        }
        
        let favoriteList = ["favorites": favoriteIds]
        
        
        ConnectionUtils.performPostRequest(url: Api.removeFromFavoritesUrlV2_1.url!, parameters: try? favoriteList.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
    private func getFavorites(favorites: SessionFavoritesModel) -> [String: [String]]{
        var favoriteIds: [String] = [String]()
        for session in favorites.favorites {
            favoriteIds.append(session.id)
        }
        
        return ["favorites": favoriteIds]
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
    
    func setUserSessionSettings(settings: UserSettings, completion: @escaping (_ error: CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.userSettings.url!, parameters: try? settings.jsonDictionary()){ (data, error) in
            completion(error)
        }
    }
    
    func getSeriesSessions(seriesId: String, completion: @escaping (SeriesModel?, CustomError?) -> Void) {
        let url = Api.seriesDetails.replacingOccurrences(of: "{id}", with: seriesId)
        
        ConnectionUtils.performGetRequest(url: url.url!, parameters: nil, completion: {
            (data, error) in
            var seriesModel: SeriesModel?
            if let data = data{
                seriesModel = SeriesModel(data: data)
            }
            completion(seriesModel, error)
        })
    }
    
    func setSeriesSessionCompleted(seriesId: String, sessionId: String, duration: TimeInterval, completion: @escaping (_ error: CustomError?) -> Void){
        let url = Api.seriesCompletedSession.replacingOccurrences(of: "{id}", with: seriesId)
        let paramters = ["sessionId" : sessionId, "duration" : duration] as [String : Any]
        ConnectionUtils.performPostRequest(url: url.url!, parameters: paramters){ (data, error) in
            completion(error)
        }
    }

    func getSessionComments(sessionId: String, completion: @escaping (CommentsModel?, CustomError?) -> Void) {
        let url = Api.sessionCommentsListUrl.replacingOccurrences(of: "{id}", with: sessionId)
        ConnectionUtils.performGetRequest(url: url.url!, parameters: nil, completion: {
            (data, error) in
            var commentsModel: CommentsModel?
            if let data = data{
                commentsModel = CommentsModel(data: data)
            }
            completion(commentsModel, error)
        })
    }
    
    func addSessionComment(sessionId: String, content:String, rating: Int, completion: @escaping (_ error: CustomError?) -> Void) {
        let url = Api.sessionWriteCommentUrl.replacingOccurrences(of: "{id}", with: sessionId)
        let paramters = ["content" : content, "rate" : rating] as [String : Any]
        ConnectionUtils.performPostRequest(url: url.url!, parameters: paramters){ (data, error) in
            completion(error)
        }
    }
    
    func updateSessionComment(commentId:String, content:String, rating: Int, completion: @escaping (_ error: CustomError?) -> Void) {
        let url = Api.sessionUpdateCommentUrl.replacingOccurrences(of: "{id}", with: commentId)
        print("url: \(url)")
        
        let paramters = ["content" : content, "rate" : rating] as [String : Any]
        ConnectionUtils.performPostRequest(url: url.url!, parameters: paramters){ (data, error) in
            completion(error)
        }
    }
}
