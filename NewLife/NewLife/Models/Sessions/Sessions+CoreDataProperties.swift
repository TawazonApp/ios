//
//  Sessions+CoreDataProperties.swift
//  NewLife
//
//  Created by Shadi on 08/04/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//
//

import Foundation
import CoreData


extension Sessions {
    
    @NSManaged public var id: String!
    @NSManaged public var userId: String!
    @NSManaged public var name: String!
    
    @NSManaged public var author: String?
    @NSManaged public var descriptionString: String?
    @NSManaged public var duration: Int32
    @NSManaged public var free: Bool
    @NSManaged public var audioFilePath: String?
    @NSManaged public var imageFilePath: String?
    @NSManaged public var thumbnailFilePath: String?
    @NSManaged public var isFavorite: Bool
    
    
    @NSManaged public var audioUrl: String?
    @NSManaged public var audioSource: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var shareLink: String?
    
    @NSManaged public var playBackgroundSound: Bool
    
    
    @nonobjc public class func sessionsFetchRequest() -> NSFetchRequest<Sessions> {
        return NSFetchRequest<Sessions>(entityName: "Sessions")
    }
    
    private class func createRecord(context: NSManagedObjectContext) -> Sessions {
        let entity = NSEntityDescription.entity(forEntityName: "Sessions", in: context)
        return NSManagedObject(entity: entity!, insertInto: context) as! Sessions
    }
    
    class func createRecord(sessionModel: SessionModel, userId: String, _ context: NSManagedObjectContext) -> Sessions {
        let session = createRecord(context: context)
        session.setValues(sessionModel: sessionModel, userId: userId)
        return session
    }
    
    private func setValues(sessionModel: SessionModel,  userId: String) {
        
        self.userId = userId
        self.id = sessionModel.id
        self.name = sessionModel.name
        self.author = sessionModel.author
        self.duration = Int32(sessionModel.duration)
        
        self.imageUrl = sessionModel.imageUrl
        self.audioUrl = sessionModel.audioUrl
        self.audioSource = sessionModel.audioSource
        self.thumbnailUrl = sessionModel.thumbnailUrl
        
        self.imageFilePath = sessionModel.localImagePath
        self.audioFilePath = sessionModel.localAudioPath
        self.thumbnailFilePath = sessionModel.localThumbnailPath
        self.shareLink = sessionModel.shareLink
        
        self.free = sessionModel.isFree()
        self.isFavorite = sessionModel.isFavorite()
        self.descriptionString = sessionModel.descriptionString
        self.playBackgroundSound = sessionModel.playBackgroundSound
    }
    
}

