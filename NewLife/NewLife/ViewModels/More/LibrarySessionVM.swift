//
//  LibrarySessionVM.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
enum SessionDownloadStatus {
    case downloading
    case downloaded
    case none
}

class LibrarySessionVM: BaseSessionVM {
    
    init(session: SessionModel) {
        super.init()
        self.session = session
    }
    
    var name: String? {
        return session?.name
    }
    
    var descriptionString: String? {
        return session?.descriptionString
    }
    
    var durationString: String? {
        guard let duration = session?.duration else { return nil }
        return durationString(seconds: duration)
    }
    
    var imageUrl: URL? {
        return session?.thumbnailUrl?.url
    }
    
    var localImageUrl: URL? {
        if let localImageUrl = session?.localThumbnailPath, localImageUrl.isEmptyWithTrim == false {
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
    
    private func durationString(seconds: Int) -> String {
        return seconds.seconds2Duration
    }
    
    func download() {
        guard let session = session else { return }
        LocalSessionsManager.shared.downloadSession(session: session) {(error) in
            
        }
    }
    
    func deleteSession(completion: @escaping (CustomError?) -> Void) {
        guard let session = session else { return }
        LocalSessionsManager.shared.deleteSessionFromDownload(session: session) {(error) in
            completion(error)
        }
        
    }
    
}
