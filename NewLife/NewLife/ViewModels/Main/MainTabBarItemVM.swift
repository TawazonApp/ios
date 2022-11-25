//
//  MainTabBarItemVM.swift
//  NewLife
//
//  Created by Shadi on 26/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MainTabBarItemVM: NSObject {
    
    var id: String!
    var title: String!
    var imageName: String?
    var gradientColors: [CGColor]!
    var isSelected: Bool = false
    
    init(id: String) {
        super.init()
        self.id = id
        self.title = title(id: id)
        self.imageName = imageName(id: id)
        self.gradientColors = mainTabItemsGradientColors(id: id).map({ return $0.cgColor})
    }
    
    
    private func title(id: String) -> String {
        var title: String = ""
        guard let itemId = MainTabBarView.tabBarItemsIds(rawValue: id) else {
            return title
        }
        
        switch itemId {
        case .home:
            title = "HomeTabTitle".localized
            break
        case .todayActivity:
            title = "TodayActivityTabTitle".localized
            break
        case .podcasts:
            title = "PodcastsTabTitle".localized
            break
        case .children:
            title = "ChildrenTabTitle".localized
            break
        case .meditations:
            title = "MeditationsTabTitle".localized
            break
            
        }
        return title
    }
    
    private func imageName(id: String) -> String? {
        var image: String? = nil
        guard let itemId = MainTabBarView.tabBarItemsIds(rawValue: id) else {
            return image
        }
        
        switch itemId {
        case .home:
            image = "HomeTab"
            break
        case .todayActivity:
            image = "TodayActivityTab"
            break
        case .podcasts:
            image = "PodcastTab"
            break
        case .children:
            image = "ChildrenTab"
            break
        case .meditations:
            image = "MeditationsTab"
            break
            
        }
        return image
    }
    
    private func mainTabItemsGradientColors(id: String) -> [UIColor] {
        var colors: [UIColor] = []
        guard let itemId = MainTabBarView.tabBarItemsIds(rawValue: id) else {
            return colors
        }
        
        switch itemId {
        case .home:
            colors = [UIColor.bubblegum, UIColor.lightPurple]
            break
        case .todayActivity:
            colors = [UIColor.lightSlateBlue, UIColor.mauve]
            break
        case .podcasts:
            colors = [UIColor.mayaBlue, UIColor.royalBlue]
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
}
