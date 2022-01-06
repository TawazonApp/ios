//
//  MySoulViewController.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MySoulViewController: CategoryViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        category = CategoryVM(id: CategoryIds.mySoul, service: SessionServiceOffline(service: SessionServiceFactory.service()))
        
    }
    
}

