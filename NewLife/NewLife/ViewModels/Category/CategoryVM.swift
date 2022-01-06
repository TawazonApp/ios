//
//  CategoryVM.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

enum CategoryIds: String {
    case myBody = "38"
    case meditations = "25"
    case mySoul = "36"
    case children = "30"
}

class CategoryVM: NSObject {
    
    var id: String!
    var name: String!
    var backgroundColor: UIColor!
    var gradiantColors: [CGColor]!
    var titleColor: UIColor!
    var subCategoryTextColor: UIColor!
    var subCategoryBackgroundColor: UIColor!
    var imageName: String!
    var summary: String!
    
    var subCategories = [SubCategoryVM] ()
    
    var category: CategoryModel? {
        didSet {
            initializeSubCategories()
        }
    }
    
    let service: SessionService!
    
    var page: Int = 1
    let pageSize: Int = 20
    
    init(id: CategoryIds, service: SessionService) {
        self.service = service
        super.init()
        
        self.id = id.rawValue
        self.name = title(id: id)
        self.imageName = imageName(id: id)
        self.gradiantColors = mainTabItemsGradientColors(id: id).map({ return $0.cgColor})
        self.titleColor = titleColor(id: id)
        self.summary = summary(id: id)
        self.backgroundColor = backgroundColor(id: id)
        let subCategoryColors = subCategoryColor(id: id)
        subCategoryTextColor = subCategoryColors.textColor
        subCategoryBackgroundColor = subCategoryColors.backgroundColor
    }
    
    private func initializeSubCategories() {
        subCategories = category?.subCategories?.map({ return SubCategoryVM(subCategory: $0, backgroundColor: backgroundColor, gradiantColors: gradiantColors, cellTextColor: subCategoryTextColor, cellBackgroundColor: subCategoryBackgroundColor, service: service)
        }) ?? []
    }
    
    func fetchCategory(completion: @escaping (CustomError?) -> Void) {
        service.fetchCategoryData(categoryId: id, page: page, pageSize: pageSize) { [weak self] (category, error) in
            
            if error == nil {
                self?.category = category
            }
            completion(error)
        }
    }
}


extension CategoryVM {
    
    private func title(id: CategoryIds) -> String {
        var title: String!
        
        switch id {
        case .myBody:
            title = "MyBodyViewTitle".localized
            break
        case .mySoul:
            title = "MySoulViewTitle".localized
            break
        case .children:
            title = "ChildrenViewTitle".localized
            break
        case .meditations:
            title = "MeditationsViewTitle".localized
            break
            
        }
        return title
    }
    
    private func titleColor(id: CategoryIds) -> UIColor {
        var color: UIColor!
        
        switch id {
        case .myBody:
            color = UIColor.darkTwo
            break
        case .mySoul:
            color = UIColor.white
            break
        case .children:
            color = UIColor.darkTwo
            break
        case .meditations:
            color = UIColor.white
            break
            
        }
        return color
    }
    
    private func summary(id: CategoryIds) -> String {
        var summary: String!
        
        switch id {
        case .myBody:
            summary = "MyBodySummaryText".localized
            break
        case .mySoul:
            summary = "MySoulSummaryText".localized
            break
        case .children:
            summary = "ChildrenSummaryText".localized
            break
        case .meditations:
            summary = "MeditationsSummaryText".localized
            break
            
        }
        return summary
    }
    
    
    private func imageName(id: CategoryIds) -> String {
        var image: String!
        
        switch id {
        case .myBody:
            image = "MyBodyHeader"
            break
        case .mySoul:
            image = "MySoulHeader"
            break
        case .children:
            image = "ChildrenHeader"
            break
        case .meditations:
            image = "MeditationsHeader"
            break
            
        }
        return image
    }
    
    private func backgroundColor(id: CategoryIds) -> UIColor {
        var color: UIColor!
        
        switch id {
        case .myBody:
            color = UIColor.lightPeach
            break
        case .mySoul:
            color = UIColor.lavenderTwo
            break
        case .children:
            color = UIColor.camoGreen
            break
        case .meditations:
            color = UIColor.blueberry
            break
            
        }
        return color
    }
    
    private func mainTabItemsGradientColors(id: CategoryIds) -> [UIColor] {
        var colors: [UIColor]!
        
        switch id {
        case .myBody:
            colors = [UIColor.salmon, UIColor.bubbleGumPink]
            break
        case .mySoul:
            colors = [UIColor.babyPurple, UIColor.perrywinkle]
            break
        case .children:
            colors = [UIColor.paleOliveGreen, UIColor.paleTeal]
            break
        case .meditations:
            colors = [UIColor.powderPink, UIColor.lighterPurple]
            break
        }
        return colors
    }
    
    private func subCategoryColor(id: CategoryIds) -> (textColor: UIColor, backgroundColor: UIColor) {
        
        var colors = (textColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        if id == .myBody {
            colors.backgroundColor = UIColor.white.withAlphaComponent(0.72)
            colors.textColor = UIColor.darkTwo
        }
       return colors
    }
}
