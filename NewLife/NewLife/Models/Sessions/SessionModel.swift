//
//  SessionModel.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct SessionModel: Codable {
    
    let id: String
    let name: String
    let descriptionString: String?
    let duration: Int
    let author: String?
    var imageUrl: String?
    var thumbnailUrl: String?
    var audioUrl: String
    var audioSource: String
    let free: Int
    var favorite: Int
    var localThumbnailPath: String?
    var localImagePath: String?
    var localAudioPath: String?
    var shareLink: String?
    let playBackgroundSound: Bool
    let audioSources: [AudioSourceModel]
    var completed: Bool?
    var locked: Bool?
//    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case descriptionString = "content"
        case duration
        case author
        case free
        case favorite
        case imageUrl = "image"
        case thumbnailUrl = "thumbnail"
        case audioUrl = "audio"
        case audioSource = "audioSource"
        case localThumbnailPath
        case localImagePath
        case localAudioPath
        case shareLink = "share_link"
        case playBackgroundSound = "allow_background_music"
        case audioSources
        case completed
        case locked
//        case type
    }
    
    func isFavorite() -> Bool {
        return favorite.boolValue()
    }
    
    func isFree() -> Bool {
        return free.boolValue()
    }
    
}

struct AudioSourceModel: Codable {
    let title, code: String
    let dialects: [Dialect]
    
    enum CodingKeys: String, CodingKey {
        case title, code
        case dialects = "items"
    }
}

// MARK: - Item
struct Dialect: Codable {
    let title, code: String
    let stream, download: String
    let duration: Int
    let hash: String
    
}
extension SessionModel {
    
    init(session: Sessions) {
        
        self.id = session.id
        self.name = session.name
        self.descriptionString = session.descriptionString
        self.duration = Int(session.duration)
        self.author = session.author ?? ""
        self.localImagePath = session.imageFilePath
        self.localAudioPath = session.audioFilePath
        self.localThumbnailPath = session.thumbnailFilePath
        self.free = session.free.intValue()
        self.favorite = session.isFavorite.intValue()
        self.imageUrl = session.imageUrl
        self.thumbnailUrl = session.thumbnailUrl
        self.audioUrl = session.audioUrl ?? ""
        self.audioSource = session.audioSource ?? ""
        self.playBackgroundSound = session.playBackgroundSound
        self.audioSources = []
        self.completed = session.completed
        self.locked = session.locked
//        self.type = session.type
    }
 
    init?(data: Data) {
        if let me = try? newJSONDecoder().decode(SessionModel.self, from: data) {
            self = me
        } else {
            return nil
        }
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else {
            return nil
            
        }
        self.init(data: data)
    }
        
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
      
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
       
        descriptionString = try container.decodeIfPresent(String.self, forKey: .descriptionString) ?? ""
        
        duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        
        author = try container.decodeIfPresent(String.self, forKey: .author)
        
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
       
        thumbnailUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl)
        
        audioUrl = try container.decodeIfPresent(String.self, forKey: .audioUrl) ?? ""
        
        audioSource = try container.decodeIfPresent(String.self, forKey: .audioSource) ?? ""
        
        free = try container.decodeIfPresent(Int.self, forKey: .free) ?? 0
        
        favorite = try container.decodeIfPresent(Int.self, forKey: .favorite) ?? 0
        
        shareLink =  try container.decodeIfPresent(String.self, forKey: .shareLink)
        
        playBackgroundSound = try container.decode(Bool.self, forKey: .playBackgroundSound)
        
        audioSources = try container.decode([AudioSourceModel].self, forKey: .audioSources)
        
        completed = try container.decodeIfPresent(Bool.self, forKey: .completed)
        
        locked = try container.decodeIfPresent(Bool.self, forKey: .locked)
        
//         type = try container.decodeIfPresent(String.self, forKey: .type)
         
        localImagePath = nil
        localAudioPath = nil
        localThumbnailPath = nil
        setLocalPathesIfFound()
    }
    
    private mutating func setLocalPathesIfFound() {
        
        localImagePath = nil
        localAudioPath = nil
        localThumbnailPath = nil
        
        if let userId =  UserDefaults.userId(), let session = DatabaseManager.shared.fetchSessionId(sessionId: id, userId: userId) {
            
            //Delete local sessions
            if isEqual(remote: self, local: session) == false {
                LocalSessionsManager.shared.deleteLocalSession(session: session)
                return
            }
            localImagePath = session.imageFilePath
            localAudioPath = session.audioFilePath
            localThumbnailPath = session.thumbnailFilePath
        }
    }
    
    private func isEqual(remote: SessionModel, local: Sessions) -> Bool {
       
        return (remote.id == local.id && remote.name == local.name && remote.descriptionString == local.descriptionString && remote.audioUrl == local.audioUrl && remote.audioSource == local.audioSource && remote.imageUrl == local.imageUrl && remote.thumbnailUrl == local.thumbnailUrl && remote.shareLink == local.shareLink)
    }
}


extension SessionModel {
    var isLock: Bool {
        return (self.isFree() == false && UserDefaults.isPremium() == false)
    }
}
