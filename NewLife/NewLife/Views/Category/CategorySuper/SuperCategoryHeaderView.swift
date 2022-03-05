//
//  SuperCategoryHeaderView.swift
//  Tawazon
//
//  Created by mac on 22/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol TopTabBarHeaderViewDelegate: class {
    func categoryTapped(index: Int)
}


class SuperCategoryHeaderView : CategoryHeaderView{

    @IBOutlet weak var topTabBar: TopTabBarView!
    var topBarDelegate: TopTabBarHeaderViewDelegate?
    
    override var category: CategoryVM! {
        didSet{
            if (category as? SuperCategoryVM) != nil {
                subCategories = category.subCategories
                if UIApplication.isRTL() {
                    subCategories.reverse()
                }
                fillData()
                if topTabBar != nil {
                    topTabBar.delegate = self
                }
                
            }
        }
    }
    override func updateSizeStyle(ratio: CGFloat) {
        super.updateSizeStyle(ratio: ratio)
        
        if self.topTabBar != nil {
            scaleFactor = 0.05
            let scale = scaleFactor * (1 - ratio)
            
            topTabBar.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3).isActive = true
            UIView.animate(withDuration: 0.1) {
                self.topTabBar.transform = CGAffineTransform(scaleX: 1 - scale, y: 1 - scale )
                self.superview?.layoutIfNeeded()
            }
            
        }
    }
}
extension SuperCategoryHeaderView: TopTabBarViewDelegate {
    
    func tabItemTapped(index: Int) {
        Rate.rateApp()
        topBarDelegate?.categoryTapped(index: index)
    }
}
