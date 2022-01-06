//
//  TESTViewController.swift
//  NewLife
//
//  Created by Shadi on 21/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class TESTViewController: UIViewController {
    
    @IBOutlet weak var gradientView: GradientView!
    
    let initialColors: [CGColor] = [UIColor.midnight.cgColor, UIColor.darkBlueGrey.cgColor,UIColor.darkGreyBlue.cgColor, UIColor.grape.cgColor]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apply()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func apply() {
       // gradientView.applyGradientColor(colors: initialColors, startPoint: .top, endPoint: .bottom)
    }
    
}
