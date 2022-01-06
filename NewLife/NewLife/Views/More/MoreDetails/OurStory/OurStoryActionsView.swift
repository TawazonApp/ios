//
//  OurStoryActionsView.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol OurStoryActionsViewDelegate: class {
    func rateAppTapped()
    func shareAppTapped()
}

class OurStoryActionsView: GradientView {
    
    @IBOutlet weak var rateAppView: OurStoryActionView!
    @IBOutlet weak var shareAppView: OurStoryActionView!
    @IBOutlet var separators: [UIView]!
    
    weak var delegate: OurStoryActionsViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        
        rateAppView.delegate = self
        shareAppView.delegate = self
    }
    
    private func initialize() {
        
        applyGradientColor(colors: [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.29).cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor], startPoint: .top, endPoint: .bottom)
        
        for separator in separators {
            separator.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        }
    }
    
    func fillData() {
        rateAppView.imageName = "RatingApp"
        rateAppView.title = "RateAppActionTitle".localized
        
        shareAppView.imageName = "ShareApp"
        shareAppView.title = "ShareAppActionTitle".localized
    }
}

extension OurStoryActionsView: OurStoryActionViewDelegate {
    
    func actionTapped(view: OurStoryActionView) {
        
        if view == rateAppView {
            delegate?.rateAppTapped()
        }
        
        if view == shareAppView {
            delegate?.shareAppTapped()
        }
    }
    
    
}
