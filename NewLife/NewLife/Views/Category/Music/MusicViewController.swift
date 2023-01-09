//
//  MusicViewController.swift
//  Tawazon
//
//  Created by mac on 20/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class MusicViewController: SuperCategoryViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        category = SuperCategoryVM(id: CategoryIds.music, service: SessionServiceOffline(service: SessionServiceFactory.service()))
        
    }
    
}

extension MusicViewController {
    
    class func instantiate() -> MusicViewController {
        
        let storyboard = UIStoryboard(name: "Categories", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: MusicViewController.identifier) as! MusicViewController
        return viewController
    }
    
}

