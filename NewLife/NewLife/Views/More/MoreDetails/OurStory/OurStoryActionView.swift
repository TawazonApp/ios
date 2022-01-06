//
//  OurStoryActionView.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol OurStoryActionViewDelegate: class {
    func actionTapped(view: OurStoryActionView)
}

class OurStoryActionView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    weak var delegate: OurStoryActionViewDelegate?
    
    var imageName: String? {
        didSet {
            imageView.image = (imageName != nil) ? UIImage(named: imageName!) : nil
        }
    }
    
    var title: String? {
        didSet {
           titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
    }
    
    private func initialize() {
        imageView.contentMode = .center
        
        titleLabel.font = UIFont.kacstPen(ofSize: 17)
        titleLabel.textColor = UIColor.white
        imageView.layer.applySketchShadow(color: UIColor.white, alpha: 0.3, x: 0, y: 0, blur: 6, spread: 0.0)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        delegate?.actionTapped(view: self)
        
        UIView.animate(withDuration: 0.15, animations: {
            self.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        }) { (finish) in
            
            UIView.animate(withDuration: 0.15, animations: {
                self.backgroundColor = UIColor.clear
            })
        }
    }
}
