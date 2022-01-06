//
//  DatabaseManager.swift
//  NewLife
//
//  Created by Shadi on 14/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class DatabaseManager: NSObject {
    
    static let shared = DatabaseManager()
    lazy var delegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = delegate.persistentContainer.viewContext
    
    private override init() {}
    
    func saveSession(sessionModel: SessionModel, userId: String) -> Bool {
        _ = Sessions.createRecord(sessionModel: sessionModel, userId: userId, context)
        
        return saveContext()
    }
    
    func deleteSession(session: Sessions) -> Bool {
        context.delete(session)
        return saveContext()
    }
    
    func fetchSessions(userId: String) -> [Sessions] {
        let fetchRequest = Sessions.sessionsFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@", userId)
    
       return (try? context.fetch(fetchRequest)) ?? []
    }
    
    func fetchSessionId(sessionId: String, userId: String) -> Sessions? {
        let fetchRequest = Sessions.sessionsFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userId == %@ AND id == %@", userId, sessionId)
        
        return (try? context.fetch(fetchRequest))?.first
    }
    
    private func saveContext() -> Bool {
        if context.hasChanges {
            return ((try? context.save()) != nil) ? true : false
        }
        return false
    }
}
