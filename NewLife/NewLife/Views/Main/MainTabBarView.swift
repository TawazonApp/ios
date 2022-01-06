//
//  MainTabBarView.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

protocol MainTabBarViewDelegate: class {
    func tabItemTapped(index: Int)
}

class MainTabBarView: UIView {
    
    @IBOutlet var items : [MainTabBarItemView]!
    
    weak var delegate: MainTabBarViewDelegate?
    
    lazy var dataItems: [MainTabBarItemVM] =  {
        return  tabBarItemsIds.allCases.map({ return MainTabBarItemVM(id: $0.rawValue ) })
    }()
    
    let animationDuration: TimeInterval = 0.75
    var selectedIndex: Int = 0
    
    enum tabBarItemsIds: String {
        case home = "1"
        case myBody = "2"
        case meditations = "3"
        case mySoul = "4"
        case children = "5"
        static let allCases:[tabBarItemsIds] = [.home, .myBody, .meditations, .mySoul, .children]
        
        static func getItemId(forCategory categoryId: String) -> tabBarItemsIds? {
           let categoryId = CategoryIds(rawValue: categoryId)
            
            switch categoryId {
            case .myBody:
                return tabBarItemsIds.myBody
            case .children:
                return tabBarItemsIds.children
            case .mySoul:
                return tabBarItemsIds.mySoul
            case .meditations:
                return tabBarItemsIds.meditations
            default:
                return nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        selectedIndex = 0
        
        for (index,data) in dataItems.enumerated() {
            data.isSelected = (index == selectedIndex)
            items[index].data = data
            items[index].delegate = self
        }
    }
    
    func animateItems()  {
        for item in items {
            let translationX = UIApplication.isRTL() ? -item.frame.origin.x : item.frame.origin.x
            item.transform = CGAffineTransform(translationX: translationX, y: 0)
            UIView.animate(WithDuration: animationDuration, timing: .easeOutQuart, animations: {
                item.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
}

extension MainTabBarView: MainTabBarItemViewDelegate {
    
    func openTap(id: tabBarItemsIds) {
        
        let index = dataItems.firstIndex { (item) -> Bool in
            item.id == id.rawValue
        }
        guard index != nil && index != selectedIndex else {
            return
        }
        
        items[selectedIndex].updateStyle(isSelected: false)
        let oldSelectedData = dataItems[selectedIndex]
        
        (id.rawValue == tabBarItemsIds.home.rawValue || oldSelectedData.id ==  tabBarItemsIds.home.rawValue) ? SystemSoundID.play(sound: .Sound2) :  SystemSoundID.play(sound: .Sound1)
        
        selectedIndex = index!
        items[safe: selectedIndex]?.updateStyle(isSelected: true)
        delegate?.tabItemTapped(index: selectedIndex)
    }
    
    func itemTapped(item: MainTabBarItemVM) {
        
        guard let index = dataItems.firstIndex(of: item), index != selectedIndex else {
            return
        }
        
        items[selectedIndex].updateStyle(isSelected: false)
        let oldSelectedData = dataItems[selectedIndex]
        
        (item.id == tabBarItemsIds.home.rawValue || oldSelectedData.id ==  tabBarItemsIds.home.rawValue) ? SystemSoundID.play(sound: .Sound2) :  SystemSoundID.play(sound: .Sound1)
        
        selectedIndex = index
        
        delegate?.tabItemTapped(index: selectedIndex)
    }
}
