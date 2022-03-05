//
//  TopTabBarView.swift
//  Tawazon
//
//  Created by mac on 02/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol TopTabBarViewDelegate: class {
    func tabItemTapped(index: Int)
}
enum topTabBarItemsIds: String {
    case meditations = "0"
    case myBody = "1"
    case mySoul = "2"
    
    static let allCases:[topTabBarItemsIds] = [.meditations, .myBody, .mySoul]
}
class TopTabBarView: UIView {

    
    var selectedIndex: Int = 0
    @IBOutlet var items : [TopTabBarItemView]!
    weak var delegate: TopTabBarViewDelegate?
    lazy var dataItems: [TopTabBarItemVM] =  {
        return  topTabBarItemsIds.allCases.map({ return TopTabBarItemVM(id: $0.rawValue ) })
    }()
    
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
}

extension TopTabBarView: TopTabBarItemViewDelegate{
    
    func itemTapped(item: TopTabBarItemVM) {
        guard let index = dataItems.firstIndex(of: item), index != selectedIndex else {
            return
        }
        
        items[selectedIndex].updateStyle(isSelected: false)
        selectedIndex = index
        
        delegate?.tabItemTapped(index: selectedIndex)
    }
    
}
