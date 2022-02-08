//
//  SubCategorySectionVM.swift
//  Tawazon
//
//  Created by mac on 24/01/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SubCategorySectionVM {
    var sessions: [CategorySessionVM] = []
    let service: SessionService!
    var id: String
    var name: String
    var pageSize: Int = 20
    
    var pagingData = (page: 0, processing: false, hasMore: true)
    
    init(service: SessionService, subCategoryId: String, subCategoryName: String) {
        self.id = subCategoryId
        self.service = service
        self.name = subCategoryName
    }
    
    func getSessions(completion: @escaping ( _ error: CustomError?) -> Void) {
        guard pagingData.processing == false, pagingData.hasMore == true else {
            completion(CustomError(message: "fetchMoreItemsFailedError".localized, statusCode: nil))
            return
        }
        
        pagingData.processing = true
        let nextPage = pagingData.page + 1
        let pageSize = self.pageSize
        service.fetchSubCategorySectionSessions(subCategoryId: id, page: nextPage, pageSize: pageSize) { [weak self] (subCategory, error) in
            self?.pagingData.processing = false
            
            if error == nil {
                
                self?.pagingData.page = nextPage
                self?.pagingData.hasMore = subCategory?.sessions?.count ?? 0 >= pageSize
                self?.name = subCategory?.item.name ?? ""
                if let sessionsModel = subCategory?.sessions {
                    self?.appendSessions(sessions: sessionsModel )
                }
            }
            completion(error)
        }
    }
    private func appendSessions(sessions: [SessionModel]) {
        let sessions = sessions.map({ return CategorySessionVM(session: $0)})
        self.sessions.append(contentsOf: sessions)
    }
}
