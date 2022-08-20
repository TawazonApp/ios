//
//  BaseLibrarySessionVM.swift
//  Tawazon
//
//  Created by mac on 08/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class BaseLibrarySessionVM: BaseSessionVM {
    let service: SessionService!
    
    init(service: SessionService, session: SessionModel) {
        self.service = service
        super.init()
        self.session = session
    }
    
    var name: String? {
        return session?.name
    }
    
    var durationString: String? {
        if let duration = session?.duration, session?.type == "series" {
            return "\(duration) \("seriesDurationText".localized)"
        }
        
        guard let duration = session?.duration else { return nil }
        return durationString(seconds: duration)
    }
    
    private func durationString(seconds: Int) -> String {
        return seconds.seconds2Duration
    }
    
    var isFavorite: Bool {
        return session?.isFavorite() ?? false
    }
    
    var isLock: Bool {
        guard let session = session else { return true }
        return (session.isFree() == false && UserDefaults.isPremium() == false)
    }
    
    var imageUrl: URL? {
        return session?.imageUrl?.url
    }
    
    var localImageUrl: URL? {
        if let localImageUrl = session?.localImagePath, localImageUrl.isEmptyWithTrim == false {
            return URL(fileURLWithPath: FileUtils.getFilePath(fileName: localImageUrl))
        }
        return nil
    }
    
    var downloadStatus: SessionDownloadStatus {
        if session?.localAudioPath != nil {
            return .downloaded
        }
        if let sessionId = session?.id,  LocalSessionsManager.shared.progressSessions.contains(sessionId) {
            return .downloading
        }
        return .none
    }
    
    func download() {
        guard let session = session else { return }
        LocalSessionsManager.shared.downloadSession(session: session) {(error) in
            
        }
    }
    
    //////////////////////////////////
    ///
    ///
    func addToFavorite(completion: @escaping (CustomError?) -> Void) {
        
        guard let sessionId = session?.id else {
            completion(CustomError(message: nil, statusCode: nil))
            return
        }
        
        let favoriteIds = [sessionId]
        
        service.addToFavorites(favorites: favoriteIds) { (error) in
            if error == nil {
                var data: SessionFavoriteNotificationObject
                data.sessionId = sessionId
                data.favorite = true
                NotificationCenter.default.post(name: NSNotification.Name.sessionModelFavoriteStatusChanged, object: data)
            }
            completion(error)
        }
        sendLikeSessionEvent(id: session?.id ?? "", name: session?.name ?? "")
    }
    
    private func sendLikeSessionEvent(id: String, name: String) {
        TrackerManager.shared.sendLikeSessionEvent(id: id, name: name)
    }
    
    func removeFromFavorites(completion: @escaping (CustomError?) -> Void) {
        guard let sessionId = session?.id else {
            completion(CustomError(message: nil, statusCode: nil))
            return
        }
        
        let favoriteIds = [sessionId]
        
        service.removeFromFavorites(favorites: favoriteIds) { (error) in
            if error == nil {
                var data: SessionFavoriteNotificationObject
                data.sessionId = sessionId
                data.favorite = false
                NotificationCenter.default.post(name: NSNotification.Name.sessionModelFavoriteStatusChanged, object: data)
            }
            completion(error)
        }
    }
}
