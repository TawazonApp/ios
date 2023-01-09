//
//  ChildrenViewController.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ChildrenViewController: SuperCategoryViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        category = SuperCategoryVM(id: CategoryIds.children, service: SessionServiceOffline(service: SessionServiceFactory.service()))
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
extension ChildrenViewController {
    
    class func instantiate() -> ChildrenViewController {
        
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: ChildrenViewController.identifier) as! ChildrenViewController
        return viewController
    }
    
}
