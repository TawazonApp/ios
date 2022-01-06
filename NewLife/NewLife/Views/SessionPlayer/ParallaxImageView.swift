//
//  ParallaxImageView.swift
//  NewLife
//
//  Created by Shadi on 04/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class ParallaxImageView: UIImageView {

    override func awakeFromNib() {
        superview?.awakeFromNib()
        initialize()
    }

    private func initialize() {
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
    }
    
    func animate(transform: CGAffineTransform? = nil) {
        let newTransform = transform ?? CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 60, delay: 0, options: .curveLinear, animations: { [weak self] in
             self?.transform = newTransform
        }) { [weak self] (finish) in
            if newTransform != CGAffineTransform.identity {
                self?.animate(transform: CGAffineTransform.identity)
            }
        }
    }
}
