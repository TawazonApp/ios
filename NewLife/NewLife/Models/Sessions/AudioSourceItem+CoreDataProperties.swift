//
//  AudioSourceItem+CoreDataProperties.swift
//  
//
//  Created by mac on 29/05/2022.
//
//

import Foundation
import CoreData


extension AudioSourceItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioSourceItem> {
        return NSFetchRequest<AudioSourceItem>(entityName: "AudioSourceItem")
    }

    @NSManaged public var dialect: String?
    @NSManaged public var stream: String?
    @NSManaged public var download: String?

}
