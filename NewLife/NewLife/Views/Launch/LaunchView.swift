//
//  LaunchView.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class LaunchView: GradientView {
    
    @IBOutlet weak var lightsView: LaunchGlowLightsView!
    @IBOutlet weak var sloganView: LaunchSloganView!

    let gradientDuration: TimeInterval = 0.5
    
    let colors: [CGColor] = [UIColor.duskyBlue.cgColor, UIColor.iris.cgColor, UIColor.wisteria.cgColor, UIColor.peachyPink.cgColor]
    
      let initialColors: [CGColor] = [UIColor.midnight.cgColor, UIColor.darkBlueGrey.cgColor,UIColor.darkGreyBlue.cgColor, UIColor.grape.cgColor]

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        
        self.applyGradientColor(colors: initialColors, startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        lightsView.alpha = 0.0
        
    }
    
    func animate() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + gradientDuration/3) { [weak self] in
            guard let _self = self else { return }
            _self.animateGradient(colors: _self.colors, duration: _self.gradientDuration)
        }
       
        
        lightsView.animateLights()
        sloganView.animate(delay: gradientDuration/2)
      
        lightsView.alpha = 0.0
        UIView.animate(WithDuration: gradientDuration/2, timing: .easeOutQuart, animations: {[weak self] in
            self?.lightsView.alpha = 1.0
        }, completion: nil)
        
    }

}
