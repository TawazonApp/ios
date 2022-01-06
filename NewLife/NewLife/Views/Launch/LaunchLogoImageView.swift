//
//  LaunchLogoImageView.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class LaunchLogoImageView: UIImageView {
    
    let initialDegree: CGFloat = -45
    let duration: TimeInterval = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {

        image = UIImage(named: "Logo")
        guard let superView = self.superview else {
            return
        }
        
        let rotate = CGAffineTransform(rotationAngle: initialDegree.deg2rad)
        let translate = CGAffineTransform(translationX: 0, y: superView.frame.height/2.0)
        
        self.transform =  rotate.concatenating(translate)
        self.alpha = 0.0
    }
    
    func animate() {
        
        guard let superView = self.superview else {
            return
        }
        
        let rotate = CGAffineTransform(rotationAngle: initialDegree.deg2rad)
        let translate = CGAffineTransform(translationX: 0, y: superView.frame.height/2.0)
        
        self.transform =  rotate.concatenating(translate)
        self.alpha = 0.0
        
        UIView.animate(WithDuration: duration, timing: .easeOutQuart, animations: { [weak self] in
            self?.transform = CGAffineTransform.identity
            self?.alpha = 1.0
        }, completion: nil)
    }

}
