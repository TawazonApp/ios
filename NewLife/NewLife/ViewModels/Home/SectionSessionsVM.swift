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
    private let homeService: HomeService
    var name: String
    var id: String
    
    init(homeService: HomeService, sectionName: String, sectionId: String) {
        self.name = sectionName
        self.id = sectionId
        self.homeService = homeService
    }
    
    func getSessions(completion: @escaping ( _ error: CustomError?) -> Void) {
        homeService.getSectionSessions(sectionId: id) { [weak self] (section, error) in
            self?.sessions = section?.items.map({ HomeSessionVM(session: $0 )}) ?? []
            completion(error)
        }
    }
}
