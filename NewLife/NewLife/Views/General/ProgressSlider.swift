//
//  CustomSlider.swift
//  Tawazon
//
//  Created by mac on 05/10/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class ProgressSlider: UISlider {
    
    private var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
    }
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        return thumb
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setValue() {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let thumb = thumbImage()
        setThumbImage(thumb, for: .normal)
    }
    
    private func thumbImage() -> UIImage {
        thumbView.frame = CGRect(x: 1, y: 0, width: 32, height: 32)
        thumbView.layer.cornerRadius = thumbView.frame.width/2
        
        let thumbImageView = UIImageView(frame: thumbView.frame)
        thumbImageView.image = UIImage(named: "ProgressTracker")
        thumbImageView.contentMode = .scaleToFill
        thumbView.addSubview(thumbImageView)
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            rendererContext.cgContext.setShadow(offset: .zero, blur: 5, color: UIColor.gray.cgColor)
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 5))
    }
}
