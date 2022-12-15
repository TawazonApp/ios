//
//  WelecomeStartView.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol WelecomeStartViewDelegate: class {
    func startViewTapped()
}

class WelecomeStartView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: WelecomeStartViewDelegate?
    var title: NSMutableAttributedString? {
        didSet {
            titleLabel.attributedText = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
    }
    
    private func initialize() {
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        self.layer.borderWidth = 1
        titleLabel.font = UIFont.kacstPen(ofSize: 20)
        titleLabel.textColor = UIColor.white
        self.clipsToBounds = true
        layer.cornerRadius = 18
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        delegate?.startViewTapped()
    }
    
}
