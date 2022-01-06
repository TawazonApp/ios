//
//  LaunchGlowLightsView.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class LaunchGlowLightsView: UIView {
    
    @IBOutlet var lights: [UIView]!
    
    let duration: TimeInterval = 1.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        
        for light in lights {
            light.layer.cornerRadius = light.frame.width/2
            light.layer.applySketchShadow(color: UIColor.white, alpha: 1.0, x: 0, y: 0, blur: 12, spread: 0)
        }
    }
    
    func animateLights() {
        var delay: TimeInterval = 0
        
        for light in lights {
           
            let scale = CGFloat(Float.random(min: 0.1, max: 1.0))
            if scale < 0.5 {
                 delay += 0.25
                 UIView.animate(WithDuration: duration, timing: .easeOutQuart, animations: {
                    light.transform = CGAffineTransform(scaleX: scale, y: scale)
                    light.alpha = 0.3
                }, completion: nil)
            }
        }
    }
    
}
