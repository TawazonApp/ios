//
//  SuperCategoryVM.swift
//  Tawazon
//
//  Created by mac on 21/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation

enum MainCategoryIds: String {
    case meditations = "25"
    case myBody = "38"
    case mySoul = "36"
}
class SuperCategoryVM: CategoryVM{
    var categorySections: [HomeSectionModel]? {
        didSet {
            fillSections()
        }
    }
    private (set) var sections: [HomeSectionVM]?
    private (set) var sessions: [CategorySessionVM]?
    
    private func fillSections() {
        guard let sections = categorySections else {
            self.sections = nil
            return
        }

        self.sections = sections.map({ HomeSectionVM(section: $0) })
        
    }
    var pagination : pagination?
    
    override func fetchCategory(completion: @escaping (CustomError?) -> Void) {
        service.fetchCategoryDetails(categoryId: id, page: page, pageSize: pageSize, completion: { (superCategory, error) in
            if error == nil {
                self.categorySections = superCategory?.sections
                self.subCategories = superCategory?.subCategories.map({ return SubCategoryVM(subCategory: $0, backgroundColor: self.backgroundColor, gradiantColors: self.gradiantColors, cellTextColor: self.subCategoryTextColor, cellBackgroundColor: self.subCategoryBackgroundColor, service: self.service)
                }) ?? []
                self.sessions = superCategory?.sessions?.map({return CategorySessionVM( session: $0)})
                self.pagination = superCategory?.pagination
            }
            completion(error)
        })
    }
    func fetchMore(completion: @escaping (CustomError?) -> Void) {
        
        if let hasMore = pagination?.hasMore, hasMore {
            service.fetchCategoryDetails(categoryId: id, page: pagination!.nextPage, pageSize: pageSize){ (category, error) in
                if error == nil{
                    self.pagination = category?.pagination
                    if let sectionsModel = category?.sections{
                        self.appendSections(sections: sectionsModel)
                    }
                    if let sessionsModel = category?.sessions{
                        self.appendSessions(sessions: sessionsModel)
                    }
                    
                }
                completion(error)
            }
        }
        
    }
    private func appendSessions(sessions: [SessionModel]) {
        let sessions = sessions.map({return CategorySessionVM( session: $0)})
        self.sessions?.append(contentsOf: sessions)
    }
    
    private func appendSections(sections: [HomeSectionModel]) {
        let sections = sections.map({return HomeSectionVM(section: $0)})
        self.sections?.append(contentsOf: sections)
    }
    
}
