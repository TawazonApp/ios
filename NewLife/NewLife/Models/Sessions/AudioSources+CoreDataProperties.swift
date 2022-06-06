//
//  AudioSources+CoreDataProperties.swift
//  
//
//  Created by mac on 29/05/2022.
//
//

import Foundation
import CoreData


extension AudioSources {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioSources> {
        return NSFetchRequest<AudioSources>(entityName: "AudioSources")
    }

    @NSManaged public var language: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension AudioSources {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: AudioSourceItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: AudioSourceItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
