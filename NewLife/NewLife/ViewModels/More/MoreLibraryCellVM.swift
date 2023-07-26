//
//  MoreLibraryCellType.swift
//  Tawazon
//
//  Created by mac on 17/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation

class MoreLibraryCellVM: NSObject{

    enum MoreLibraryCellType: CaseIterable {
        case downloads
        case favorite
    }
    
    let type: MoreLibraryCellType!
    var imageName: String?
    var title: String!
    
    init(type: MoreLibraryCellType) {
        self.type = type
        super.init()
        
        self.title = title(type: type)
        self.imageName = imageName(type: type)
    }
}
extension MoreLibraryCellVM{
    
    private func title(type: MoreLibraryCellType) -> String {
        var title: String = ""
        switch type {
        case .downloads:
            title = "MoreDownloadLibraryTitle".localized
            break
        case .favorite:
            title = "MoreFavoritesTitle".localized
            break
        }
        return title
    }
    
    private func imageName(type: MoreLibraryCellType) -> String{
        var name : String = ""
        switch type{
        case .downloads:
            name = "MoreDownloads"
            break
        case .favorite:
            name = "MoreFavorites"
            break
        }
        return name
    }

}
