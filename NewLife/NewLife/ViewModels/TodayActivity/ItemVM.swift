//
//  QuoteVM.swift
//  Tawazon
//
//  Created by mac on 22/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
class ItemVM {
    var id: String
    var title: String?
    var image, thumbnail: String?
    var content: String?
    var authorName: String?
    var paletteColor: String?
    var author: Contributor?
    var mainItem: SessionModel?
    
    init(item: ItemModel) {
        self.id = item.id
        self.title = item.title
        self.image = item.image
        self.thumbnail = item.thumbnail
        self.content = item.content
        self.authorName = item.authorName
        self.paletteColor = item.paletteColor
        self.author = item.author
    }
    
    init(id: String, title: String?, image: String?, thumbnail: String?, content: String?, authorName: String?, paletteColor: String?, author: Contributor?, mainItem: SessionModel?) {
        self.id = id
        self.title = title
        self.image = image
        self.thumbnail = thumbnail
        self.content = content
        self.authorName = authorName
        self.paletteColor = paletteColor
        self.author = author
        self.mainItem = mainItem
    }
}
