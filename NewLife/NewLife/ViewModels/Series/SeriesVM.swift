//
//  SeriesVM.swift
//  Tawazon
//
//  Created by mac on 31/07/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
class SeriesVM: NSObject{
    var details: SeriesDetailsModel?
    var sessions: [SessionVM]?
    var service: SessionService!
    
    init(service: SessionService){
        self.service = service
    }
    
    func fetchSeries(id: String, completion: @escaping (CustomError?) -> Void){
        service.getSeriesSessions(seriesId: id, completion: {
            (model, error) in
            self.details = model?.seriesDetails
            self.sessions = model?.sessions.map({SessionVM(service: self.service, session: $0)}) ?? []
            completion(error)
        })
    }
    
    func setCompletedSession(sessionId: String, duration: Int, completion: @escaping (CustomError?) -> Void){
        if let id = details?.id {
            service.setSeriesSessionCompleted(seriesId: id, sessionId: sessionId, duration: TimeInterval(duration), completion: {
                (error) in
                completion(error)
            })
        }
        
    }
    
    func addToFavorite(completion: @escaping (CustomError?) -> Void) {
        
        guard let seriesId = details?.id else{
            completion(CustomError(message: nil, statusCode: nil))
            return
        }
        
        let favoriteIds = [seriesId]
        
        service.addToFavorites(favorites: favoriteIds) { (error) in
            if error == nil {
                var data: SessionFavoriteNotificationObject
                data.sessionId = seriesId
                data.favorite = true
                self.details?.favorite = true
            }
            completion(error)
        }
        sendLikeSessionEvent(id: details?.id ?? "", name: details?.title ?? "")
    }
    
    private func sendLikeSessionEvent(id: String, name: String) {
        TrackerManager.shared.sendLikeSessionEvent(id: id, name: name)
    }
    
    func removeFromFavorites(completion: @escaping (CustomError?) -> Void) {
        guard let seriesId = details?.id else {
            completion(CustomError(message: nil, statusCode: nil))
            return
        }
        
        let favoriteIds = [seriesId]
        
        service.removeFromFavorites(favorites: favoriteIds) { (error) in
            if error == nil {
                var data: SessionFavoriteNotificationObject
                data.sessionId = seriesId
                data.favorite = false
                self.details?.favorite = false
            }
            completion(error)
        }
    }
}
