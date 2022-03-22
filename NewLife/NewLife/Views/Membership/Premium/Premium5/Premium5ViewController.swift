//
//  Premium5ViewController.swift
//  Tawazon
//
//  Created by mac on 22/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class Premium5ViewController: UIViewController {

    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitlePart1: UILabel!
    @IBOutlet weak var headerTitlePart2: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var purchaseButton: GradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    }
    
    private func initialize(){
        gradientView.applyGradientColor(colors: [UIColor.regalBlue.cgColor, UIColor.mariner.cgColor], startPoint: .top, endPoint: .bottom)
        
        
    }


}
