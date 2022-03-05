//
//  PodcastsViewController.swift
//  Tawazon
//
//  Created by mac on 20/02/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class PodcastsViewController: SuperCategoryViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        category = SuperCategoryVM(id: CategoryIds.podcasts, service: SessionServiceOffline(service: SessionServiceFactory.service()))
        
    }
    
}


