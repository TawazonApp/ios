//
//  HomeVM.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class HomeVM: NSObject {
    
    var service: HomeService!
    var homeSections: [HomeSectionModel]? {
        didSet {
            fillSections()
        }
    }
    
    var pages: [PremiumPage]?
    
    private (set) var sections: [HomeSectionVM]?
    
    var isRamadan: Bool {
        let isRamadan =  UserInfoManager.shared.subscription?.types.items.first?.discountCampaign?.isRamadan
        return isRamadan ?? false
    }
    
    init(service: HomeService) {
        self.service = service
    }
    
    private func fillSections() {
        guard let sections = homeSections else {
            self.sections = nil
            return
        }

        self.sections = sections.map({ HomeSectionVM(section: $0) })
    }
}

extension HomeVM {
    
    func getHomeSections(completion: @escaping (CustomError?) -> Void) {
        service.fetchHomeSections { [weak self] (sections, error) in
            self?.homeSections = sections?.sections
            self?.pages = sections?.pages
            completion(error)
        }
    }
}
