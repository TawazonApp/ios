//
//  SubCategoryVM.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class SubCategoryVM: NSObject {
    
    var id: String!
    var name: String!
    var isHome: Bool!
    var backgroundColor: UIColor!
    var gradiantColors: [CGColor]!
    var cellTextColor: UIColor!
    var cellBackgroundColor: UIColor!
    var sessions: [CategorySessionVM]!
    
    let subCategory: SubCategoryModel!
    let service: SessionService!
    var pageSize: Int = 20
    
    var pagingData = (page: 1, processing: false, hasMore: true)
   
    init(subCategory: SubCategoryModel, backgroundColor: UIColor, gradiantColors: [CGColor], cellTextColor: UIColor, cellBackgroundColor: UIColor, service: SessionService) {
        self.service = service
        self.subCategory = subCategory
        
        self.id = subCategory.id
        self.name = subCategory.name
        self.isHome = subCategory.isHome
        self.backgroundColor = backgroundColor
        self.gradiantColors = gradiantColors
        self.cellTextColor = cellTextColor
        self.cellBackgroundColor = cellBackgroundColor
        
        sessions = subCategory.sessions?.map({ return CategorySessionVM(session: $0)})
        
        pagingData.hasMore = (subCategory.sessions?.count ?? 0 >= pageSize)
    }
    
    func fetchMore(completion: @escaping (CustomError?) -> Void) {
        
        guard pagingData.processing == false, pagingData.hasMore == true else {
            completion(CustomError(message: "fetchMoreItemsFailedError".localized, statusCode: nil))
            return
        }
        
        pagingData.processing = true
        let nextPage = pagingData.page + 1
        let pageSize = self.pageSize
        
        service.fetchSubCategorySessions(subCategoryId: id, page: nextPage, pageSize: pageSize) { [weak self] (subCategory, error) in
            
            self?.pagingData.processing = false
            
            if error == nil {
                
                self?.pagingData.page = nextPage
                self?.pagingData.hasMore = subCategory?.sessions?.count ?? 0 >= pageSize
                
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
