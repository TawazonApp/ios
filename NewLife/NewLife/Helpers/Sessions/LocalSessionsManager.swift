//
//  SessionDownloadManager.swift
//  NewLife
//
//  Created by Shadi on 14/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class LocalSessionsManager: NSObject {
    
    static let shared = LocalSessionsManager(service: SessionServiceFactory.service())
    
    let service: SessionService!

    var progressSessions = [String]() {
        didSet {
            sendProgressSessionsNotification()
        }
    }

    private init(service: SessionService) {
        self.service = service
    }
    
     func deleteSessionFromDownload(session: SessionModel, completion: @escaping (CustomError?) -> Void) {
        
        if let error = deleteLocalSession(sessionId: session.id) {
            completion(error)
            return
        }
    
        service.removeFromDownloadList(sessionId: session.id) { (error) in
            completion(error)
        }
        
    }
    
    func deleteAllLocalUserSessions() {
        fetchLocalDatabaseSessions().forEach { (session) in
            deleteLocalSession(session: session)
            
        }
    }
    
    private func deleteLocalSession(sessionId: String) -> CustomError? {
        
        guard let userId = UserDefaults.userId() else {
            return CustomError(message: "userNotDefineError".localized, statusCode: nil)
        }
        
        guard let session = DatabaseManager.shared.fetchSessionId(sessionId: sessionId, userId: userId) else {
            return nil
        }
        
        deleteLocalSession(session: session)
        return nil
    }
    
    func deleteLocalSession(session: Sessions) {
        
        if let audioFileName = session.audioFilePath {
            let localAudioPath = FileUtils.getFilePath(fileName: audioFileName)
            _ = FileUtils.deleteFile(filePath: localAudioPath)
        }
        
        if let imageFileName = session.imageFilePath {
            let imagePath =  FileUtils.getFilePath(fileName: imageFileName)
            _ = FileUtils.deleteFile(filePath: imagePath)
            
        }
        
        if let thumbnailFileName = session.thumbnailFilePath {
            let thumbnailFile =  FileUtils.getFilePath(fileName: thumbnailFileName)
            _ = FileUtils.deleteFile(filePath: thumbnailFile)
            
        }
        
        var data: SessionDownloadedNotificationObject
        data.sessionId = session.id
        data.localAudioPath = nil
        data.localImagePath = nil
        data.localThumbnailPath = nil
        
        NotificationCenter.default.post(name: NSNotification.Name.sessionModelDownloadValuesChanged, object: data)
        
        _ = DatabaseManager.shared.deleteSession(session: session)
    }
    
    func downloadSession(session: SessionModel, completion: @escaping (CustomError?) -> Void) {
        let sessionId = session.id
        progressSessions.append(sessionId)
        
        service.addToDownloadList(sessionId: session.id) { (error) in
        }
        
        performDownloadSession(session: session) { [weak self] (newSession, error) in
            self?.sendSessionDownloadedNotification(session: newSession)
            completion(error)
            self?.progressSessions.remove(element: sessionId)
        }
    }
    

    private func sendProgressSessionsNotification() {
        NotificationCenter.default.post(name: NSNotification.Name.downloadSessionsProgressChanged, object: nil)
    }
    
    private func sendSessionDownloadedNotification(session: SessionModel?) {
        guard let session = session else { return }
        
        var data: SessionDownloadedNotificationObject
        data.sessionId = session.id
        data.localAudioPath = session.localAudioPath
        data.localImagePath = session.localImagePath
        data.localThumbnailPath = session.localThumbnailPath
        
        NotificationCenter.default.post(name: NSNotification.Name.sessionModelDownloadValuesChanged, object: data)
    }
    
  private func performDownloadSession(session: SessionModel, completion: @escaping (_ session: SessionModel? ,CustomError?) -> Void) {
    
        guard let userId = UserDefaults.userId() else {
            completion(nil, CustomError(message: "userNotDefineError".localized, statusCode: nil))
            return
        }
        
        downloadSessionAudio(session: session, userId: userId) { [weak self](localAudioPath, error) in

            if let error = error {
                completion(nil, error)
                return
            }
            
            self?.downloadSessionImage(session: session, userId: userId) { (localImagePath, localThumbnailPath, error) in
                
                var newSession = session
                newSession.localAudioPath = localAudioPath
                newSession.localThumbnailPath = localThumbnailPath
                newSession.localImagePath = localImagePath
                _ = DatabaseManager.shared.saveSession(sessionModel: newSession, userId: userId)
                completion(newSession, nil)
            }
        }
        
    }
    
    private func downloadSessionAudio(session: SessionModel, userId: String, completion: @escaping (_ localAudioPath: String?, CustomError?) -> Void) {
        
        guard let remoteAudioUrl = session.audioSource.url else  {
        
            completion(nil, CustomError(message: "invalidSessionFilePathError".localized, statusCode: nil))
            return
        }
        
         let localAudio = getSessionAudioLocalUrl(id: session.id, userId: userId, fileExtension: remoteAudioUrl.pathExtension)
        
        service.downloadSessionFile(localFileUrl: localAudio.fullUrl, remoteUrl: remoteAudioUrl) { (error) in
            completion(localAudio.path, error)
        }
    }
    
    private func downloadSessionImage(session: SessionModel, userId: String, completion: @escaping (_ localImagePath: String?, _ localThumbnailPath: String?, CustomError?) -> Void) {
        
        guard let remoteImageUrl = session.imageUrl?.url else  {
            completion(nil, nil, CustomError(message: "invalidSessionFilePathError".localized, statusCode: nil))
            return
        }
        
        guard let remoteThumbnailUrl = session.thumbnailUrl?.url else  {
            completion(nil, nil, CustomError(message: "invalidSessionFilePathError".localized, statusCode: nil))
            return
        }
        
         let localImage = getSessionImageLocalUrl(id: session.id, userId: userId, fileExtension: remoteImageUrl.pathExtension)
        
         let localThumbnail = getSessionThumbnailLocalUrl(id: session.id, userId: userId, fileExtension: remoteThumbnailUrl.pathExtension)
        
        service.downloadSessionFile(localFileUrl: localImage.fullUrl, remoteUrl: remoteImageUrl) { [weak self] (error) in
            
            self?.service.downloadSessionFile(localFileUrl: localThumbnail.fullUrl, remoteUrl: remoteThumbnailUrl) { (error) in
                completion(localImage.path, localThumbnail.path, error)
            }
            
        }
    }
    
  
    
    private func getSessionAudioLocalUrl(id: String, userId: String, fileExtension: String) -> (fullUrl:URL, path: String) {
        
        let localSessionName = getLocalSessionAudioName(id: id, userId: userId, fileExtension: fileExtension)
        
        let fullUrl = URL(fileURLWithPath: FileUtils.getFilePath(fileName: localSessionName))
        
        return (fullUrl: fullUrl, path: localSessionName)
    }
    
    private func getSessionImageLocalUrl(id: String,userId: String, fileExtension: String) -> (fullUrl:URL, path: String) {
        
        let localSessionName = getLocalSessionImageName(id: id, userId: userId, fileExtension: fileExtension)
        
        let fullUrl = URL(fileURLWithPath: FileUtils.getFilePath(fileName: localSessionName))
        
        return(fullUrl: fullUrl, path: localSessionName)
    }
    
    private func getSessionThumbnailLocalUrl(id: String,userId: String, fileExtension: String) -> (fullUrl:URL, path: String) {
        
        let localSessionName = getLocalSessionThumbnailName(id: id, userId: userId, fileExtension: fileExtension)
        
        let fullUrl = URL(fileURLWithPath: FileUtils.getFilePath(fileName: localSessionName))
        
        return(fullUrl: fullUrl, path: localSessionName)
    }
    
    
    private func getLocalSessionAudioName(id: String, userId: String, fileExtension: String) -> String {
        return "sessionAudio_\(userId)_\(id).\(fileExtension)"
    }
    
    private func getLocalSessionImageName(id: String, userId: String, fileExtension: String) -> String {
        return "sessionImage_\(userId)_\(id).\(fileExtension)"
    }
    
    private func getLocalSessionThumbnailName(id: String, userId: String, fileExtension: String) -> String {
        return "sessionThumbnail_\(userId)_\(id).\(fileExtension)"
    }
    
    func fetchLocalSessions() ->[SessionModel] {
        return fetchLocalDatabaseSessions().map({ SessionModel(session: $0)})
    }
    
    func fetchLocalSession(id: String) -> SessionModel? {
        if let localSession =  fetchLocalDatabaseSession(sessionId: id) {
            return SessionModel(session: localSession)
        }
        return nil
    }
    
    private func fetchLocalDatabaseSessions () -> [Sessions] {
        guard let userId = UserDefaults.userId() else {
            return []
        }
        return DatabaseManager.shared.fetchSessions(userId: userId)
    }
    
    private func fetchLocalDatabaseSession (sessionId: String) -> Sessions? {
        guard let userId = UserDefaults.userId() else {
            return nil
        }
        return DatabaseManager.shared.fetchSessionId(sessionId: sessionId, userId: userId)
    }
 
 

}
