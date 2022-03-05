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


