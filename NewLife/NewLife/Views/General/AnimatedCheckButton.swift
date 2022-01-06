//
//  AnimatedCheckButton.swift
//  NewLife
//
//  Created by Shadi on 19/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//https://github.com/entotsu/TKAnimatedCheckButton/blob/master/TKAnimatedCheckButton/Classes/TKAnimatedCheckButton.swift

import Foundation
import CoreGraphics
import QuartzCore
import UIKit


public class AnimatedCheckButton : UIButton {
    
    public var color = UIColor.white.cgColor {
        didSet {
            setShapeColor()
        }
    }
    public var checkColor = UIColor.white.withAlphaComponent(0.25).cgColor {
        didSet {
            setShapeColor()
        }
    }
    
    public var checkBackgroundColor = UIColor.white.withAlphaComponent(0.25) {
        didSet {
            setShapeColor()
        }
    }
    
    
    private func setShapeColor() {
        shape.strokeColor = checked ? checkColor : color
        self.backgroundColor = checked ? checkBackgroundColor : UIColor.clear
    }
    
    let path: CGPath = {
        
        let p = CGMutablePath()
        
        p.move(to: CGPoint(x: 5.07473346, y: 20.2956615))

        p.addCurve(to: CGPoint(x: 2, y: 34) , control1: CGPoint(x: 3.1031115, y: 24.4497281), control2: CGPoint(x: 2, y: 29.0960413))

        
        p.addCurve(to:  CGPoint(x: 34, y: 66), control1: CGPoint(x: 2, y: 51.673112), control2: CGPoint(x: 16.326888, y: 66))

        p.addCurve(to: CGPoint(x: 66, y: 34),control1: CGPoint(x: 51.673112, y: 66), control2: CGPoint(x: 66, y: 51.673112))

        p.addCurve(to: CGPoint(x: 34, y: 2), control1: CGPoint(x: 66, y: 16.326888), control2: CGPoint(x: 51.673112, y: 2))

        p.addCurve(to: CGPoint(x: 5.16807419, y: 20.1007094), control1: CGPoint(x: 21.3077047, y: 2), control2: CGPoint(x: 10.3412842, y: 9.38934836))

        
        p.addLine(to: CGPoint(x: 29.9939289, y: 43.1625671))
        p.addLine(to: CGPoint(x: 56.7161293, y: 17.3530369))

        return p
    }()
    let pathSize:CGFloat = 70
    
    let circleStrokeStart: CGFloat = 0.0
    let circleStrokeEnd: CGFloat = 0.738
    
    let checkStrokeStart: CGFloat = 0.8
    let checkStrokeEnd: CGFloat = 0.97
    
    
    var shape: CAShapeLayer! = CAShapeLayer()
    
    let lineWidth:CGFloat = 4
    let lineWidthBold:CGFloat = 5
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    
    private func initialize() {
        let defaultPoint = self.frame.origin
        
        var size = frame.width
        if frame.width < frame.height {
            size = frame.height
        }
        let scale:CGFloat = size / pathSize
        
        self.shape.path = path
        
        self.shape.strokeColor = color
        
        self.shape.position = CGPoint(x: frame.height/2, y: frame.height/2)
        
        self.shape.strokeStart = circleStrokeStart
        self.shape.strokeEnd = circleStrokeEnd
        
        shape.lineWidth = lineWidth
        
        for layer in [self.shape ] {
            layer!.fillColor = nil
            layer!.miterLimit = 4
            layer!.lineCap = CAShapeLayerLineCap.round
            layer!.masksToBounds = true
            
            let strokingPath = layer!.path!.copy(strokingWithWidth: 4, lineCap: CGLineCap.round, lineJoin: CGLineJoin.miter, miterLimit: 4)
            layer!.bounds = strokingPath.boundingBox
            layer!.actions = [
                "strokeStart": NSNull(),
                "strokeEnd": NSNull(),
                "transform": NSNull()
            ]
            layer!.transform = CATransform3DMakeScale(scale, scale, 1);
            self.layer.addSublayer(layer!)
        }
        self.frame.origin = defaultPoint
        self.layer.cornerRadius = self.frame.height/2.0
        self.layer.masksToBounds = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
       initialize()
    }
    
    let timingFunc = CAMediaTimingFunction(controlPoints: 0.44,-0.04,0.64,1.4)//0.69,0.12,0.23,1.27)
    let backFunc = CAMediaTimingFunction(controlPoints: 0.45,-0.36,0.44,0.92)
    
    public var checked: Bool = false {
        
        didSet {
            let strokeStart = CABasicAnimation(keyPath: "strokeStart")
            let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            let lineWidthAnim = CABasicAnimation(keyPath: "lineWidth")
            setShapeColor()
            if checked {
                strokeStart.toValue = checkStrokeStart
                strokeStart.duration = 0.3//0.5
                strokeStart.timingFunction = timingFunc
                
                strokeEnd.toValue = checkStrokeEnd
                strokeEnd.duration = 0.3//0.6
                strokeEnd.timingFunction = timingFunc
                
                lineWidthAnim.toValue = lineWidthBold
                lineWidthAnim.beginTime = 0.2
                lineWidthAnim.duration = 0.1
                lineWidthAnim.timingFunction = timingFunc
            } else {
                strokeStart.toValue = circleStrokeStart
                strokeStart.duration = 0.2//0.5
                strokeStart.timingFunction = backFunc//CAMediaTimingFunction(controlPoints: 0.25, 0, 0.5, 1.2)
                //                strokeStart.beginTime = CACurrentMediaTime() + 0.1
                strokeStart.fillMode = CAMediaTimingFillMode.backwards
                
                strokeEnd.toValue = circleStrokeEnd
                strokeEnd.duration = 0.3//0.6
                strokeEnd.timingFunction = backFunc//CAMediaTimingFunction(controlPoints: 0.25, 0.3, 0.5, 0.9)
                lineWidthAnim.toValue = lineWidth
                lineWidthAnim.duration = 0.1
                lineWidthAnim.timingFunction = backFunc
            }
            shape.ocb_applyAnimation(animation: strokeStart)
            shape.ocb_applyAnimation(animation: strokeEnd)
            shape.ocb_applyAnimation(animation: lineWidthAnim)
        }
 
    }
}

extension CALayer {
    
    func ocb_applyAnimation(animation: CABasicAnimation) {
        let copy = animation.copy() as! CABasicAnimation
        if copy.fromValue == nil, let copyPath = copy.keyPath  {
            copy.fromValue = presentation()?.value(forKeyPath: copyPath)
        }
        add(copy, forKey: copy.keyPath)
        if let copyPath = copy.keyPath {
            setValue(copy.toValue, forKey: copyPath)
        }
        
    }

}
