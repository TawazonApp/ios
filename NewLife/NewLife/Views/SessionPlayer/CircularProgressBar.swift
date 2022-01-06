//
//  CircularProgressBar.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation
import UIKit

public class CircularProgressBar: CALayer {
    
    private var circularPath: UIBezierPath!
    private var trackShapeLayer: CAShapeLayer!
    private let rotateTransformation = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
    
    public var isUsingAnimation: Bool!
    public var progress: CGFloat = 0 {
        didSet {
            trackShapeLayer.strokeEnd = progress
            updateProgress(fromValue: oldValue)
        }
    }
    
    public init(radius: CGFloat, position: CGPoint, innerTrackColor: UIColor, lineWidth: CGFloat) {
        super.init()
        
        let startAngle: CGFloat = .pi
        circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: startAngle, endAngle: startAngle + .pi * 2, clockwise: true)
        
        trackShapeLayer = CAShapeLayer()
        trackShapeLayer.strokeColor = innerTrackColor.cgColor
        trackShapeLayer.position = position
        trackShapeLayer.strokeEnd = progress
        trackShapeLayer.lineWidth = lineWidth
        trackShapeLayer.lineCap = CAShapeLayerLineCap.round
        trackShapeLayer.fillColor = UIColor.clear.cgColor
        trackShapeLayer.path = circularPath.cgPath
        trackShapeLayer.transform = rotateTransformation
        trackShapeLayer.applySketchShadow(color: innerTrackColor, alpha: 1.0, x: 0, y: 0, blur: 7, spread: 0)
        addSublayer(trackShapeLayer)
    }
    
    private func updateProgress(fromValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = fromValue
        animation.toValue = progress
        animation.duration = 0.5
        trackShapeLayer.add(animation, forKey: "trackShapeLayer")
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



