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
    var image: String?
    var content: String?
    var authorName: String?
    
    init(item: ItemModel) {
        self.id = item.id
        self.title = item.title
        self.image = item.image
        self.content = item.content
        self.authorName = item.authorName
    }
    
    init(id: String, title: String?, image: String?, content: String?, authorName: String?) {
        self.id = id
        self.title = title
        self.image = image
        self.content = content
        self.authorName = authorName
    }
}
