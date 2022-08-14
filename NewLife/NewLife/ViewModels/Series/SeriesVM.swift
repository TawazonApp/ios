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
            service.setSeriesSessionCompleted(seriesId: id, sessionId: sessionId, duration: duration, completion: {
                (error) in
                completion(error)
            })
        }
        
    }
}
