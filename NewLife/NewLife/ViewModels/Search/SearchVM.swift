//
//  SearchVM.swift
//  Tawazon
//
//  Created by mac on 27/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SearchVM: NSObject {
    private (set) var sections: [HomeSectionVM]?
    var categories: [SearchCategoryVM]?
    
    var service: SessionService!
    
    init(service: SessionService) {
        self.service = service
    }
    
    func getSearchData(query: String?, completion: @escaping (CustomError?) -> Void) {
        
        service.fetchSearchResults(page:1 , pageSize: 20, query: query) {
            (searchResult, error) in
            if let sections = searchResult?.sections{
                self.sections = sections.map({ HomeSectionVM(section: $0) })
            }
            if let categories = searchResult?.categories{
                self.categories = categories.map({SearchCategoryVM(sarchCategory: $0, backgroundColor: .yellow, gradiantColors: [UIColor.liliac.cgColor, UIColor.blueberry.cgColor], cellTextColor: .black, cellBackgroundColor: .red)})
            }
            completion(error)
        }
    }
}

