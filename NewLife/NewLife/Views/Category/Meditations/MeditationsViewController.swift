//
//  MeditationsViewController.swift
//  NewLife
//
//  Created by Shadi on 26/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MeditationsViewController: SuperCategoryViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        category = SuperCategoryVM(id: CategoryIds.meditations, service: SessionServiceOffline(service: SessionServiceFactory.service()))
        
    }
    
}
