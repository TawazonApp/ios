//
//  HomeViewBackground.swift
//  Tawazon
//
//  Created by Shadi on 14/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class HomeBackgroundView: UIView {
    @IBOutlet weak var topView: GradientView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        let colors = [UIColor.darkSeven.cgColor, UIColor.darkSeven.withAlphaComponent(0.58).cgColor, UIColor.darkSeven.withAlphaComponent(0.0).cgColor]
        topView.backgroundColor = UIColor.clear
        topView.applyGradientColor(colors: colors, startPoint: GradientPoint.bottom, endPoint: GradientPoint.top)
        bottomView.backgroundColor = UIColor.darkSeven
    }
}
