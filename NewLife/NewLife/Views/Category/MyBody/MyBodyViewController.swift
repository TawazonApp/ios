//
//  MyBodyViewController.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MyBodyViewController: CategoryViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        category = CategoryVM(id: CategoryIds.myBody, service: SessionServiceOffline(service: SessionServiceFactory.service()))
        
    }
    
}
