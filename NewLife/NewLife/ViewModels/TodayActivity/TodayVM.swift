//
//  TodayVM.swift
//  Tawazon
//
//  Created by mac on 21/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation

import UIKit

class TodayVM: NSObject {
    
    var service: TodayService!
    var todaySections: [TodaySectionModel]? {
        didSet {
            fillSections()
        }
    }
    var userName: String {
        let name = (UserInfoManager.shared.getUserInfo()?.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return String(name.split(separator: " ").first ?? "")
    }
    private (set) var sections: [TodaySectionVM]?
    
    var isRamadan: Bool {
        let isRamadan =  UserInfoManager.shared.subscription?.types.items.first?.discountCampaign?.isRamadan
        return isRamadan ?? false
    }
    
    init(service: TodayService) {
        self.service = service
    }
    
    private func fillSections() {
        guard let sections = todaySections else {
            self.sections = nil
            return
        }

        self.sections = sections.map({ TodaySectionVM(section: $0) })
//        
//        let feelingSection = sections.filter{
//            return $0.style == .feelingSelection
//        }
//        if feelingSection.first?.sessions.count ?? 0 == 0{
//            let feelingSectionModel : TodaySectionModel = sections[1]
//            self.sections?.insert(TodaySectionVM(id: UUID().uuidString, title: feelingSectionModel.title_2, subTitle: feelingSectionModel.subtitle_2, content: feelingSectionModel.content_2, iconUrl: feelingSectionModel.image, sessions: [], style: .feelingSelectionSessions, buttonLabel: feelingSectionModel.buttonLabel, moreLabel: feelingSectionModel.moreLabel), at: 2)
//        }
        
    }
}

extension TodayVM {
    
    func getTodaySections(completion: @escaping (CustomError?) -> Void) {
        service.fetchTodaySections { [weak self] (sections, error) in
            self?.todaySections = sections?.sections
            completion(error)
        }
    }
    
    func setTodayQuoteViewed(quoteId: String, completion: @escaping (CustomError?) -> Void) {
        service.setQuoteViewed(quoteId: quoteId) { (error) in
            if error == nil{
                var quoteSection = self.sections?.filter{
                    return $0.style == .singleQuote
                }
                quoteSection?.first?.completed = true
            }
            
            completion(error)
        }
    }
}
