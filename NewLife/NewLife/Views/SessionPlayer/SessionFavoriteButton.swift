//
//  SessionFavoriteButton.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class SessionFavoriteButton: UIButton {
    
    var isFavorite: Bool = false {
        didSet {
            updateStyle()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        updateStyle()
        self.tintColor = UIColor.white
        self.layer.cornerRadius = self.frame.height/2
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    func updateStyle() {
        let image = isFavorite ? UIImage(named: "FavoriteFill") : UIImage(named: "Favorite")
        self.tintColor = isFavorite ? UIColor.lightSlateBlue : UIColor.white
        self.setImage(image, for: .normal)
    }
    
    func animate() {
        
        guard let imageView = self.imageView else {
            return
        }
        
        let transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        let duration: TimeInterval = 0.25
        
        UIView.transition(with: imageView, duration: duration, options: .curveEaseOut, animations: {
            imageView.transform = transform
        }) { (finish) in
            
            imageView.transform = CGAffineTransform.identity
            
            UIView.transition(with: imageView, duration: duration, options: .curveEaseOut, animations: {
               imageView.transform = transform
            }) { (finish) in
                imageView.transform = CGAffineTransform.identity
            }
        }
        
    }
}
