//
//  HomeSectionVM.swift
//  Tawazon
//
//  Created by Shadi on 14/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class HomeSectionVM {
    var id: String
    var title: String
    var subTitle: String?
    var iconUrl: String?
    var sessions: [HomeSessionVM]
    var style: HomeSectionStyle
    var bannerType: HomeBannerStyle?
    let categoryId: String?
    
    init(section: HomeSectionModel) {
        self.id = section.id
        self.title = section.title
        self.subTitle = section.subtitle
        self.iconUrl = section.icon
        self.sessions = section.sessions.map({ HomeSessionVM(session: $0) })
        style = section.style ?? .list
        bannerType = section.bannerType
        categoryId = section.categoryId
    }
    
    init(id: String, title: String, subTitle: String?, iconUrl: String?, sessions: [SessionModel], style: HomeSectionStyle) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.iconUrl = iconUrl
        self.sessions = sessions.map({ HomeSessionVM(session: $0) })
        self.style = style
        self.categoryId = nil
    }
}
