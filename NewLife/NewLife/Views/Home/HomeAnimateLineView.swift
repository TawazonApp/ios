//
//  HomeAnimateLineView.swift
//  NewLife
//
//  Created by Shadi on 26/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class HomeAnimateLineView: UIView {

    let duration: TimeInterval = 1.0
    
    weak var shapeLayer: CAShapeLayer?
    
    func draw(_ animated: Bool) {
        
        self.shapeLayer?.removeFromSuperlayer()
        
        // create whatever path you want
        
        let path = UIBezierPath()
        var point =  CGPoint(x: frame.width/2.0, y: 0)
        path.move(to: point)
        point.y = frame.height
        path.addLine(to: point)
        
        // create shape layer for that path
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = path.cgPath
        
        shapeLayer.applySketchShadow(color: UIColor.white, alpha: 1.0, x: 0, y: 0, blur: 16, spread: 0)
        
        self.layer.addSublayer(shapeLayer)
        
        // animate it
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0.5
            animation.duration = duration
            animation.timingFunction =  CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            shapeLayer.add(animation, forKey: "MyAnimation")
        }
        
        self.shapeLayer = shapeLayer
    }


}
