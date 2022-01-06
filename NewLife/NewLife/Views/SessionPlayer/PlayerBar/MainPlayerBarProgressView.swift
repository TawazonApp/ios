//
//  MainPlayerBarProgressView.swift
//  NewLife
//
//  Created by Shadi on 20/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MainPlayerBarProgressView: UIView {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    var progress: Float = 0.0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    var currentTime: String? {
        didSet {
            currentTimeLabel.text = currentTime ?? "--:--"
        }
    }
    
    var remainingTime: String? {
        didSet {
            remainingTimeLabel.text = remainingTime ?? "--:--"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        currentTimeLabel.font = UIFont.kacstPen(ofSize: 11)
        currentTimeLabel.textColor = UIColor.charcoalGrey
        
        remainingTimeLabel.font = UIFont.kacstPen(ofSize: 11)
        remainingTimeLabel.textColor = UIColor.charcoalGrey.withAlphaComponent(0.9)
        
        progressView.trackTintColor = UIColor.charcoalGreyTwo.withAlphaComponent(0.16)
        progressView.progressTintColor = UIColor.cornflowerTwo
        
        currentTime = nil
        remainingTime = nil
    }
}
