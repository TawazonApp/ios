//
//  QuoteVM.swift
//  Tawazon
//
//  Created by mac on 22/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
class QuoteVM {
    var id: String
    var title: String?
    var image: String?
    var content: String?
    var authorName: String?
    
    init(quote: QuoteModel) {
        self.id = quote.id
        self.title = quote.title
        self.image = quote.image
        self.content = quote.content
        self.authorName = quote.authorName
    }
    
    init(id: String, title: String?, image: String?, content: String?, authorName: String?) {
        self.id = id
        self.title = title
        self.image = image
        self.content = content
        self.authorName = authorName
    }
}
