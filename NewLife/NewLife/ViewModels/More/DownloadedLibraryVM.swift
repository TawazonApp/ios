//
//  DownloadedLibraryVM.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class DownloadedLibraryVM: NSObject {
    
    var sessions: [LibrarySessionVM] = []
    let service: SessionService!
    let pageSize: Int = 20
    
    var pagingData = (page: 1, processing: false, hasMore: true)
    
    init(service: SessionService) {
        self.service = SessionServiceOffline(service: service)
    }
    
    func fetchData(completion: @escaping (CustomError?) -> Void) {
        
        let page = 1
        let pageSize = self.pageSize
        
        pagingData.page = page
        pagingData.hasMore = true
        pagingData.processing = true
        
        fetchSessions(page: page, pageSize: pageSize) { [weak self] (sessions, error) in
            
            self?.pagingData.processing = false
            
            if error == nil {
                self?.pagingData.hasMore = sessions.count >= pageSize
                self?.sessions.removeAll()
                self?.sessions.append(contentsOf: sessions)
            } else {
                if self?.sessions.count == 0 {
                    self?.sessions = LocalSessionsManager.shared.fetchLocalSessions().map({ return (LibrarySessionVM(session: $0))})
                }
            }
            completion(error)
        }
    }
    
    func fetchMore(completion: @escaping (CustomError?) -> Void) {
        
        guard pagingData.processing == false, pagingData.hasMore == true else {
            completion(CustomError(message: "fetchMoreItemsFailedError".localized, statusCode: nil))
            return
        }
        
        pagingData.processing = true
        let nextPage = pagingData.page + 1
        let pageSize = self.pageSize
        
        fetchSessions(page: nextPage, pageSize: pageSize) { [weak self] (sessions, error) in
            
            self?.pagingData.processing = false
            
            if error == nil {
                self?.pagingData.page = nextPage
                self?.pagingData.hasMore = sessions.count >= pageSize
                
                self?.sessions.append(contentsOf: sessions)
            }
            
            completion(error)
        }
    }
        
}

extension DownloadedLibraryVM {
    
    private func fetchSessions(page: Int, pageSize: Int, completion: @escaping ([LibrarySessionVM], CustomError?) -> Void) {
        
        var sessions = [LibrarySessionVM]()
        
        service.fetchDownloadedSessions(page: page, pageSize: pageSize) { (sessionsModel, error) in
            for session in sessionsModel?.sessions ?? [] {
                sessions.append(LibrarySessionVM(session: session))
            }
            completion(sessions, error)
        }
    }
}
