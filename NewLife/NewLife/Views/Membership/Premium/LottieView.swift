//
//  LottieView.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import Lottie

class LottieView: UIView {

    var animationView: AnimationView?
    var iconName: String! = "" {
        didSet {
            if iconName != oldValue {
                 setIcon()
            }
        }
    }

    private func setIcon() {
        if animationView == nil {
            addAnimationView()
        } else {
            animationView?.animation = Animation.named(iconName)
        }
        animationView?.play()
    }
    
    private func addAnimationView() {
        animationView = AnimationView(name: iconName)
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        animationView?.loopMode = .loop
        self.addSubview(animationView!)
        
        animationView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        animationView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        animationView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        animationView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
}
