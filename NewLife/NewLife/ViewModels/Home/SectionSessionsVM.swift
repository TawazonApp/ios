//
//  SectionSessionsVM.swift
//  Tawazon
//
//  Created by Shadi on 04/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import Foundation

class SectionSessionsVM {
    
    var sessions: [HomeSessionVM] = []
    var items: [ItemVM] = []
    private let homeService: HomeService
    var name: String
    var id: String
    var type: Int?
    
    var pageSize: Int = 20
    var pagingData = (page: 1, processing: false, hasMore: true)
    
    init(homeService: HomeService, sectionName: String, sectionId: String) {
        self.name = sectionName
        self.id = sectionId
        self.homeService = homeService
        
        
    }
    
    func getSessions(type: SectionData.SectionType,completion: @escaping ( _ error: CustomError?) -> Void) {
        
        let page = 1
        let pageSize = self.pageSize
        
        pagingData.page = page
        pagingData.hasMore = true
        pagingData.processing = true
        
        homeService.getSectionSessions(sectionId: self.id, type: type, page: page, pageSize: pageSize) { [weak self] (section, error) in
            self?.sessions = section?.items.map({ HomeSessionVM(session: $0 )}) ?? []
            self?.name = section?.section.name ?? ""
            self?.type = section?.section.type
            self?.pagingData.hasMore = section?.pagination.hasMore ?? false
            self?.pagingData.page = section?.pagination.currentPage ?? 1
            self?.pagingData.processing = false
            completion(error)
        }
    }
    
    func getMore(type: SectionData.SectionType, completion: @escaping (CustomError?) -> Void){
        guard pagingData.processing == false, pagingData.hasMore == true else {
            completion(CustomError(message: "fetchMoreItemsFailedError".localized, statusCode: nil))
            return
        }
        
        pagingData.processing = true
        let nextPage = pagingData.page + 1
        let pageSize = self.pageSize
        homeService.getSectionSessions(sectionId: id, type: type, page: nextPage, pageSize: pageSize) { [weak self] (section, error) in
            
            self?.pagingData.processing = false
            
            if error == nil {
                
                self?.pagingData.page = nextPage
                self?.pagingData.hasMore = section?.pagination.hasMore ?? false
                if let sectionSessions = section?.items {
                    self?.appendSessions(sessions: sectionSessions )
                }
            }
            completion(error)
        }
    }
    private func appendSessions(sessions: [SessionModel]) {
        let sessions = sessions.map({ return HomeSessionVM(session: $0)})
        self.sessions.append(contentsOf: sessions)
    }
}
