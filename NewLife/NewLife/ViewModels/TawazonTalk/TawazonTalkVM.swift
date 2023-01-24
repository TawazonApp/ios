//
//  TawazonTalkVM.swift
//  Tawazon
//
//  Created by mac on 18/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
class TawazonTalkVM{
    
    var service: TodayService!
    
    var id: String?
    var title, image, thumbnail, content, paletteColor: String?
    var author: Contributor?
    var mainItem: SessionModel?
    var comingSoon: ComingSoonModel?
    var tawazonTalkSections: [TawazonTalkSection]?{
        didSet{
            fillSections()
        }
    }
    init(service: TodayService) {
        self.service = service
    }
    
    private (set) var sections: [TawazonTalkSectionVM]?
    
    
    private func fillSections() {
        guard let sections = tawazonTalkSections else {
            self.sections = nil
            return
        }

        self.sections = sections.map({ TawazonTalkSectionVM(section: $0) })
    }
    
    
    func getTawazonTalkDetails(Id: String, completion: @escaping(CustomError?) -> Void) {
        service.getTawazonTalkView(id: Id, completion: {
            (model, error) in
            if let model = model{
                self.id = model.id
                self.title = model.title
                self.image = model.image
                self.thumbnail = model.thumbnail
                self.content = model.content
                self.paletteColor = model.paletteColor
                self.author = model.author
                self.comingSoon = model.comingSoon
                self.mainItem = model.mainItem
                self.tawazonTalkSections = model.sections
            }
            completion(error)
        })
    }
}
