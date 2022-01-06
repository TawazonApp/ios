//
//  SessionVM.swift
//  NewLife
//
//  Created by Shadi on 04/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class SessionVM: BaseSessionVM {
    
    let service: SessionService!
    
    init(service: SessionService, session: SessionModel) {
        self.service = service
        super.init()
        self.session = session
    }
    
  
    var id: String? {
        return session?.id
    }
    
    var name: String? {
        return session?.name
    }
    
    var author: String? {
        return session?.author
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
    
    var durationString: String? {
        guard let duration = session?.duration else { return nil }
        return durationString(seconds: duration)
    }
    
    var isFavorite: Bool {
        return session?.isFavorite() ?? false
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
    
    var audioUrl: URL? {
       return session?.audioUrl.url
    }
    
    var localAudioUrl: URL? {
        if let localAudioUrl = session?.localAudioPath, localAudioUrl.isEmptyWithTrim == false {
            return URL(fileURLWithPath: FileUtils.getFilePath(fileName: localAudioUrl))
        }
        return nil
    }
    
    var shareUrl: String? {
        return session?.shareLink
    }
    
    private func durationString(seconds: Int) -> String {
        return seconds.seconds2Duration
    }
    
    func download() {
        guard let session = session else { return }
        LocalSessionsManager.shared.downloadSession(session: session) {(error) in
        }
        sendDownloadSessionEvent(id: session.id, name: session.name)
    }
    
    func addToFavorite(completion: @escaping (CustomError?) -> Void) {
        
        guard let sessionId = id else {
            completion(CustomError(message: nil, statusCode: nil))
            return
        }
        
        let favorites = SessionFavoritesModel(favorites: [sessionId])
        
        service.addToFavorites(favorites: favorites) { (error) in
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
    
    func removeFromFavorites(completion: @escaping (CustomError?) -> Void) {
        guard let sessionId = id else {
            completion(CustomError(message: nil, statusCode: nil))
            return
        }
        
        let favorites = SessionFavoritesModel(favorites: [sessionId])
        
        service.removeFromFavorites(favorites: favorites) { (error) in
            if error == nil {
                var data: SessionFavoriteNotificationObject
                data.sessionId = sessionId
                data.favorite = false
                NotificationCenter.default.post(name: NSNotification.Name.sessionModelFavoriteStatusChanged, object: data)
            }
            completion(error)
        }
    }
    
    private func sendDownloadSessionEvent(id: String, name: String) {
        TrackerManager.shared.sendDownloadSessionEvent(id: id, name: name)
    }
    
    private func sendLikeSessionEvent(id: String, name: String) {
        TrackerManager.shared.sendLikeSessionEvent(id: id, name: name)
    }
}
