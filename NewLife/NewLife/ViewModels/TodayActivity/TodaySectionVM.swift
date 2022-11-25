//
//  TodaySectionsVM.swift
//  Tawazon
//
//  Created by mac on 21/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
class TodaySectionVM {
    var id: String
    var title: String
    var titleCompletedState: String
    var subTitle: String?
    var content: String?
    var iconUrl: String?
    var sessions: [HomeSessionVM]
    var style: TodaySectionStyle
    var bannerType: HomeBannerStyle?
    var clickable: Bool?
    let categoryId: String?
    var buttonLabel: String?
    var moreLabel: String?
    var imageUrl: String?
    var items: [QuoteVM]?
    var completed: Bool?
    
    init(section: TodaySectionModel) {
        self.id = section.id
        self.title = section.title
        self.subTitle = section.subtitle
        self.content = section.content
        self.iconUrl = section.icon
        self.sessions = section.sessions.map({ HomeSessionVM(session: $0) })
        style = section.style
        bannerType = section.bannerType
        clickable = section.clickable
        categoryId = section.categoryId
        buttonLabel = section.buttonLabel
        moreLabel = section.moreLabel
        imageUrl = section.image
        items = section.items.map({ QuoteVM(quote: $0)})
        completed = section.completed
        titleCompletedState = section.title_2
    }
    
    init(id: String, title: String, title_2: String, subTitle: String?, content: String?, iconUrl: String?, sessions: [SessionModel], style: TodaySectionStyle, buttonLabel: String?, moreLabel: String?, imageUrl: String? = "", items: [QuoteModel], completed: Bool?) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.content = content
        self.iconUrl = iconUrl
        self.sessions = sessions.map({ HomeSessionVM(session: $0) })
        self.style = style
        self.categoryId = nil
        self.buttonLabel = buttonLabel
        self.moreLabel = moreLabel
        self.imageUrl = imageUrl
        self.items = items.map({QuoteVM(quote: $0)})
        self.completed = completed
        self.titleCompletedState = title_2
    }
}
