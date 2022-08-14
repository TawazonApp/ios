//
//  SessionServiceOffline.swift
//  NewLife
//
//  Created by Shadi on 14/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

class SessionServiceOffline: SessionService {
    func fetchSearchResults(page: Int, pageSize: Int, query: String?, completion: @escaping (SearchModel?, CustomError?) -> Void) {
        service.fetchSearchResults(page: page, pageSize: pageSize, query: query){
            (serachModel, error) in
            completion(serachModel,error)
        }
    }
    
    
    let service: SessionService!
    init(service: SessionService) {
        self.service = service
    }
    
    func downloadSessionFile(localFileUrl: URL, remoteUrl: URL, completion: @escaping (CustomError?) -> Void) {
        
        service.downloadSessionFile(localFileUrl: localFileUrl, remoteUrl: remoteUrl) { (error) in
            completion(error)
        }
    }
    
    func fetchCategoryData(categoryId: String, page: Int, pageSize: Int, completion: @escaping (CategoryModel?, CustomError?) -> Void) {
        
        service.fetchCategoryData(categoryId: categoryId, page: page, pageSize: pageSize) { (categoryModel, error) in
            completion(categoryModel, error)
        }
    }
    
    func fetchCategoryDetails(categoryId: String, page: Int, pageSize:Int, completion: @escaping (SuperCategoryModel?, CustomError?) -> Void){
        
        service.fetchCategoryDetails(categoryId: categoryId, page: page, pageSize: pageSize) { (categoryModel, error) in
            completion(categoryModel, error)
        }
   }
    
    func fetchSubCategorySessions(subCategoryId: String, page: Int, pageSize: Int, completion: @escaping (SubCategoryModel?, CustomError?) -> Void) {
        
        service.fetchSubCategorySessions(subCategoryId: subCategoryId, page: page, pageSize: pageSize) { (subCategory, error) in

            completion(subCategory, error)
        }
    }
    
    func fetchDownloadedSessions(page: Int, pageSize: Int, completion: @escaping (SessionsModel?, CustomError?) -> Void) {
        
        service.fetchDownloadedSessions(page: page, pageSize: pageSize) { (sessionsModel, error) in
            completion(sessionsModel, error)
        }
        
    }
    func fetchFavoriteSessions(page: Int, pageSize: Int, completion: @escaping (SessionFavoritesModel?, CustomError?) -> Void) {
        
        service.fetchFavoriteSessions(page: page, pageSize: pageSize) { (SessionFavoritesModel, error) in
            completion(SessionFavoritesModel, error)
        }
        
    }
    
    func addToDownloadList(sessionId: String, completion: @escaping (CustomError?) -> Void) {
        service.addToDownloadList(sessionId: sessionId) { (error) in
            completion(error)
        }
    }
    
    func removeFromDownloadList(sessionId: String, completion: @escaping (CustomError?) -> Void) {
        service.removeFromDownloadList(sessionId: sessionId) { (error) in
            completion(error)
        }
    }
    
    
    func addToFavorites(favorites: SessionFavoritesModel, completion: @escaping (CustomError?) -> Void) {
        service.addToFavorites(favorites: favorites) { (error) in
            completion(error)
        }
    }
    
    func removeFromFavorites(favorites: SessionFavoritesModel, completion: @escaping (CustomError?) -> Void) {
        service.removeFromFavorites(favorites: favorites) { (error) in
            completion(error)
        }
    }
    
   func rateSession(sessionId: String, rate: Int, completion: @escaping (CustomError?) -> Void) {
        completion(nil)
    }
    
    func fetchSessionInfo(sessionId: String, completion: @escaping (SessionModel?, CustomError?) -> Void) {
        service.fetchSessionInfo(sessionId: sessionId, completion: completion)
    }
    
    func setUserSessionSettings(settings: UserSettings, completion: @escaping (_ error: CustomError?) -> Void) {
        service.setUserSessionSettings(settings: settings){ (error) in
            completion(error)
        }
    }
    
    func getSeriesSessions(seriesId: String, completion: @escaping (SeriesModel?, CustomError?) -> Void) {
        
        service.getSeriesSessions(seriesId: seriesId, completion: completion)
    }
    
    func setSeriesSessionCompleted(seriesId: String, sessionId: String, duration: Int, completion: @escaping (_ error: CustomError?) -> Void){
        service.setSeriesSessionCompleted(seriesId: seriesId, sessionId: sessionId, duration: duration, completion: completion)
    }
}
