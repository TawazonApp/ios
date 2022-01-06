//
//  SoundEffectsButton.swift
//  NewLife
//
//  Created by Shadi on 04/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class SoundEffectsButton: UIButton {
    
    let topLeftCircle:CAShapeLayer = CAShapeLayer()
    let topRightCircle:CAShapeLayer = CAShapeLayer()
    let bottomLeftCircle:CAShapeLayer = CAShapeLayer()
    let bottomRightCircle:CAShapeLayer = CAShapeLayer()
    
    let topLeftOrigin = CGPoint(x: 15, y: 15)
    let topRightOrigin = CGPoint(x: 28, y: 15)
    let bottomLeftOrigin = CGPoint(x: 15, y: 28)
    let bottomRightOrigin = CGPoint(x: 26, y: 26)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        addCircleLayer(layer: topLeftCircle, radius: 4, origin: topLeftOrigin)
        addCircleLayer(layer: topRightCircle, radius: 3, origin: topRightOrigin)
        addCircleLayer(layer: bottomLeftCircle, radius: 3, origin: bottomLeftOrigin)
        addCircleLayer(layer: bottomRightCircle, radius: 4, origin: bottomRightOrigin)
    }
    
    private func addCircleLayer(layer: CAShapeLayer, radius: CGFloat, origin: CGPoint) {
        
        layer.path = UIBezierPath(ovalIn: CGRect(x: origin.x, y: origin.y, width: radius*2, height: radius*2)).cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2
        self.layer.addSublayer(layer)
    }
    
    func animate() {
        
          self.topLeftCircle.transform = CATransform3DIdentity
        
          self.bottomRightCircle.transform = CATransform3DIdentity
          self.topRightCircle.transform = CATransform3DIdentity
          self.bottomLeftCircle.transform = CATransform3DIdentity
        
        let topLeftTransform = CATransform3DMakeTranslation(self.bottomRightOrigin.x - self.topLeftOrigin.x, self.bottomRightOrigin.y - self.topLeftOrigin.y, 0)
        
        let bottomRightTransform = CATransform3DMakeTranslation(self.topLeftOrigin.x - self.bottomRightOrigin.x, self.topLeftOrigin.y - self.bottomRightOrigin.y, 0)
        
        let topRightTransform = CATransform3DMakeTranslation(self.bottomLeftOrigin.x - self.topRightOrigin.x, self.bottomLeftOrigin.y - self.topRightOrigin.y, 0)
        
        let bottomLeftTransform = CATransform3DMakeTranslation(self.topRightOrigin.x - self.bottomLeftOrigin.x, self.topRightOrigin.y - self.bottomLeftOrigin.y, 0)
        
        
        topLeftCircle.add(animation(transform: topLeftTransform), forKey: "topLeftCircle")
        
         topRightCircle.add(animation(transform: topRightTransform), forKey: "topRightCircle")
        
        bottomLeftCircle.add(animation(transform: bottomLeftTransform), forKey: "bottomLeftCircle")
        
         bottomRightCircle.add(animation(transform: bottomRightTransform), forKey: "bottomRightCircle")
    }
    
    
    private func animation(transform: CATransform3D) -> CABasicAnimation {
        let duration: TimeInterval = SoundEffectsViewController.duration
       
        let animation = CABasicAnimation(keyPath: "transform")
        animation.toValue = NSValue(caTransform3D:transform)
        animation.duration = duration
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction.easeOutQuart
        return animation
    }
}

extension SoundEffectsViewController {
    //TODO // collection view controller
}
