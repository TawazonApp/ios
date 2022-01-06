//
//  BaseSessionVM.swift
//  NewLife
//
//  Created by Shadi on 18/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

typealias SessionFavoriteNotificationObject = (sessionId: String, favorite: Bool)

typealias SessionDownloadedNotificationObject = (sessionId: String, localAudioPath: String?, localImagePath: String?, localThumbnailPath: String? )

class BaseSessionVM: NSObject {
    
    var session: SessionModel?
    
    override init() {
        super.init()
        initializeNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteStatusChanged(_:)), name: NSNotification.Name.sessionModelFavoriteStatusChanged, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(sessionModelDownloaded(_:)), name: NSNotification.Name.sessionModelDownloadValuesChanged, object: nil)
    }
    
    @objc func favoriteStatusChanged(_ notification: Notification) {
        if let data = notification.object as? SessionFavoriteNotificationObject {
            if session?.id == data.sessionId {
                session?.favorite = data.favorite.intValue()
            }
        }
    }
    
    @objc func sessionModelDownloaded(_ notification: Notification) {
        if let data = notification.object as? SessionDownloadedNotificationObject {
            if session?.id == data.sessionId {
                session?.localAudioPath = data.localAudioPath
                session?.localImagePath = data.localImagePath
                session?.localThumbnailPath = data.localThumbnailPath
            }
        }
    }
}
