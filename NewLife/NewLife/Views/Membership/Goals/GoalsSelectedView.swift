//
//  GoalsSelectedView.swift
//  NewLife
//
//  Created by Shadi on 10/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class GoalsSelectedView: UIView {
    
    @IBOutlet var circles: [GoalCircleView]!
    @IBOutlet weak var referenceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var containerHeight: CGFloat = 300
    
    var goals: [GoalVM]!  {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        self.isHidden = true
         for (index, circle) in circles.enumerated() {
             circle.index = index
        }
    }
    
    func layoutView(containerHeight: CGFloat) {
        
        self.containerHeight = containerHeight
        
        var constant:CGFloat = 120
        if containerHeight < 370 {
            constant = 80
        } else if containerHeight < 468 {
            constant = 100
        }
        
        referenceHeightConstraint.constant = constant
        layoutIfNeeded()
        
        if let lastCircle = self.circles.sorted(by: { $0.tag < $1.tag }).last {
            self.heightConstraint.constant = lastCircle.frame.maxY
            super.layoutIfNeeded()
        }
        
        for circle in circles{
            circle.updateLayout()
        }
        
    }
    
    func animateWhenLoad() {
        SystemSoundID.play(sound: .goals)
        self.isHidden = false
        
        for (index, circle) in self.circles.sorted(by: { $0.tag < $1.tag }).enumerated() {
            circle.transform = circleTransform(index: index)
            
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                circle.transform = .identity
            }) { (finish) in
                
            }
            
        }
    }
    
    func animateWhenDismiss() {
        
        for (index, circle) in self.circles.sorted(by: { $0.tag < $1.tag }).enumerated() {
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { [weak self] in
                circle.transform = self?.circleTransform(index: index) ?? .identity
            }) { (finish) in
                
            }
            
        }
    }
    
    private func circleTransform(index: Int) -> CGAffineTransform {
        var transform: CGAffineTransform!
        if index == 0 {
             transform = CGAffineTransform.init(translationX: 0, y: -frame.height/2)
        } else if index == 1 {
            transform = CGAffineTransform.init(translationX: -frame.width/2, y: -40)
        } else if index == 2 {
            transform = CGAffineTransform.init(translationX: frame.width, y: -40)
        } else if index == 3 {
            transform = CGAffineTransform.init(translationX: -frame.width/2, y: 0)
        } else if index == 4 {
            transform = CGAffineTransform.init(translationX: frame.width, y: 0)
        } else if index == 5 {
            transform = CGAffineTransform.init(translationX: frame.width, y: 40)
        } else if index == 6 {
            transform = CGAffineTransform.init(translationX: -frame.width/2, y: 40)
        } else if index == 7 {
            transform = CGAffineTransform.init(translationX: frame.width, y: 80)
        } else if index == 8 {
            transform = CGAffineTransform.init(translationX: -frame.width/2, y: 80)
        }
        transform.tx = UIApplication.isRTL() ? transform.tx : -transform.tx
        return transform
    }
    
    private func fillData() {
        for circle in circles {
            let index = circle.tag
            circle.goal = goals[safe: index]
        }
    }

}
