//
//  FeelingSlider.swift
//  Tawazon
//
//  Created by mac on 03/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit


class FeelingSlider: UISlider {

    
    private let baseLayer = CALayer()
    private let trackLayer = CAGradientLayer()
    private let trackLayerBorder = CAGradientLayer()
    private let shape = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
    private func setup() {
        clear()
        createBaseLayer()
        createThumbImageView()
        configureTrackLayer()
        configureTrackLayerBorder()
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    private func clear() {
       tintColor = .clear
       maximumTrackTintColor = .clear
       backgroundColor = .clear
       thumbTintColor = .clear
    }
    
    private func createBaseLayer() {
        baseLayer.borderWidth = 1
        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = UIColor.white.withAlphaComponent(0.12).cgColor
        baseLayer.frame = .init(x: 0,
                                y: frame.height / 4,
                                width: frame.width,
                                height: frame.height / 2)
        baseLayer.cornerRadius = baseLayer.frame.height / 2
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    private func createThumbImageView() {
        let thumbSize = baseLayer.frame.height
        let thumbView = ThumbView(frame: .init(x: 0,
                                               y: 0,
                                               width: thumbSize,
                                               height: thumbSize))
        thumbView.layer.cornerRadius = thumbSize / 2
        let thumbSnapshot = thumbView.snapshot
        setThumbImage(thumbSnapshot, for: .normal)
        setThumbImage(thumbSnapshot, for: .highlighted)
        setThumbImage(thumbSnapshot, for: .application)
        setThumbImage(thumbSnapshot, for: .disabled)
        setThumbImage(thumbSnapshot, for: .focused)
        setThumbImage(thumbSnapshot, for: .reserved)
        setThumbImage(thumbSnapshot, for: .selected)
    }
    
    private func configureTrackLayer() {
        let firstColor = UIColor.columbiaBlue.withAlphaComponent(0.21).cgColor
        let secondColor = UIColor.lightSkyBlue.withAlphaComponent(0.4).cgColor
        trackLayer.colors = [firstColor, secondColor]
        trackLayer.startPoint = .init(x: 0, y: 0.5)
        trackLayer.endPoint = .init(x: 1, y: 0.5)
        trackLayer.frame = .init(x: 0,
                                 y: frame.height / 4,
                                 width: frame.width / 2,
                                 height: frame.height / 2)
        trackLayer.cornerRadius = trackLayer.frame.height / 2
        layer.insertSublayer(trackLayer, at: 1)
    }
    private func configureTrackLayerBorder(){
        
        trackLayerBorder.colors = [UIColor.mayaBlue.cgColor, UIColor.mauve.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        trackLayerBorder.startPoint = .init(x: 1, y: 0.5)
        trackLayerBorder.endPoint = .init(x: 0, y: 0.5)
        trackLayerBorder.frame =  .init(x: 0,
                                        y: frame.height / 4,
                                        width: frame.width / 2,
                                        height: frame.height / 2)
        trackLayerBorder.cornerRadius = trackLayer.cornerRadius
        
        
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: self.trackLayer.bounds, cornerRadius: trackLayer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        trackLayerBorder.mask = shape
        
        layer.insertSublayer(trackLayerBorder, at: 2)
    }
    
    @objc private func valueChanged(_ sender: FeelingSlider) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let thumbRectA = thumbRect(forBounds: bounds,
                                   trackRect: trackRect(forBounds: bounds),
                                   value: value)
        trackLayer.frame = .init(x: 0,
                                 y: trackLayer.frame.origin.y,
                                 width: thumbRectA.midX,
                                 height: trackLayer.frame.height)
        shape.path = UIBezierPath(rect: self.trackLayer.bounds).cgPath
        
        trackLayerBorder.frame = .init(x: 0,
                                 y: trackLayer.frame.origin.y,
                                 width: thumbRectA.midX,
                                 height: trackLayer.frame.height)

        CATransaction.commit()
    }
    
}


final class ThumbView: UIView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
 
    private func setup() {
        backgroundColor = UIColor(red: 183 / 255, green: 122 / 255, blue: 231 / 255, alpha: 1)
        let middleView = UIImageView(frame: frame)
        middleView.backgroundColor = .clear
        middleView.image = UIImage(named: "LandingFeelingsliderThumb")
        addSubview(middleView)
    }
}
