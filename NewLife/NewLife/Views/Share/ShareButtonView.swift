//
//  ShareButtonView.swift
//  Tawazon
//
//  Created by Shadi on 23/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

protocol ShareButtonViewDelegate: class {
    func shareButtonTapped(_ sender: ShareButtonView)
}

class ShareButtonView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: ShareButtonViewDelegate?
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
    }
    
    private func initialize() {
        titleLabel.font = UIFont.kacstPen(ofSize: 20)
        titleLabel.textColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
    }
    

    @objc func tapped(_ sender:  UITapGestureRecognizer) {
        delegate?.shareButtonTapped(self)
    }
}
