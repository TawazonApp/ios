//
//  LaunchSloganView.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class LaunchSloganView: UIView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    
    @IBOutlet weak var topLineHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomLineHeight: NSLayoutConstraint!
    
    let finalHeight: CGFloat = 16
    let duration: TimeInterval = 1.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        
        label.font = UIFont.lbc(ofSize: 20)
        label.textColor = UIColor.white
        label.text = "launchSlogan".localized
        
        topLineView.backgroundColor = UIColor.white
        bottomLineView.backgroundColor = UIColor.white
        
        topLineView.layer.applySketchShadow(color: UIColor.white, alpha: 1.0, x: 0, y: 0, blur: 8, spread: 0)
        
        bottomLineView.layer.applySketchShadow(color: UIColor.white, alpha: 1.0, x: 0, y: 0, blur: 8, spread: 0)
        
        topLineHeight.constant = 1
        bottomLineHeight.constant = 1
        self.superview?.layoutIfNeeded()
        self.alpha = 0.0
    }
    
    func animate(delay: TimeInterval) {
        
        topLineHeight.constant = finalHeight
        bottomLineHeight.constant = finalHeight
        
        self.alpha = 0.0
        UIView.animate(WithDuration: duration, timing: .easeOutQuart, animations: {[weak self] in
            self?.superview?.layoutIfNeeded()
            self?.alpha = 1.0
            }, completion: nil)
    }
}
