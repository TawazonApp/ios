//
//  TopTabBarItemVM.swift
//  Tawazon
//
//  Created by mac on 02/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TopTabBarItemVM: NSObject{
    var id: String!
    var title: String!
    var imageName: String?
    var backgroundImage: String?
    var gradientColors: [CGColor]!
    var isSelected: Bool = false
    
    init(id: String) {
        super.init()
        self.id = id
        self.title = title(id: id)
        self.imageName = imageName(id: id)
        self.backgroundImage = backgroundImage(id: id)
        self.gradientColors = mainTabItemsGradientColors(id: id).map({ return $0.cgColor})
    }
    private func title(id: String) -> String {
        var title: String = ""
        guard let itemId = topTabBarItemsIds(rawValue: id) else {
            return title
        }
        
        switch itemId {
        case .meditations:
            title = "MeditationsTabTitle".localized
            break
        case .myBody:
            title = "MyBodyTabTitle".localized
            break
        case .mySoul:
            title = "MySoulTabTitle".localized
            break
            
        }
        return title
    }
    
    private func imageName(id: String) -> String? {
        var image: String? = nil
        guard let itemId = topTabBarItemsIds(rawValue: id) else {
            return image
        }
        
        switch itemId {
        case .myBody:
            image = "MyBodyTab"
            break
        case .mySoul:
            image = "MySoulTab"
            break
        case .meditations:
            image = "MeditationsTab"
            break
            
        }
        return image
    }
    private func backgroundImage(id: String) -> String? {
        var image: String? = nil
        guard let itemId = topTabBarItemsIds(rawValue: id) else {
            return image
        }
        
        switch itemId {
        case .myBody:
            image = "TopTabMyBodyGradients"
            break
        case .mySoul:
            image = "TopTabMySoulGradients"
            break
        case .meditations:
            image = "TopTabMeditationsGradients"
            break
            
        }
        return image
    }
    
    private func mainTabItemsGradientColors(id: String) -> [UIColor] {
        var colors: [UIColor] = []
        guard let itemId = topTabBarItemsIds(rawValue: id) else {
            return colors
        }
        
        switch itemId {
        case .myBody:
            colors = [UIColor.salmon, UIColor.bubbleGumPink]
            break
        case .mySoul:
            colors = [UIColor.babyPurple, UIColor.perrywinkle]
            break
        case .meditations:
            colors = [UIColor.powderPink, UIColor.lighterPurple]
            break
            
        }
        return colors
    }
}
