//
//  PlayerProgressView.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class PlayerProgressView: UIView {

    var progressBar: CircularProgressBar!
    var withBase: Bool = true
    var progress: CGFloat = 0 {
        didSet {
           progressBar.progress = progress
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
       
        let radius = self.frame.width/2
        let position = CGPoint(x: radius, y: radius)
        
        progressBar = CircularProgressBar(radius: radius, position: position, innerTrackColor: UIColor.white, lineWidth: 2, withBase: withBase)
        
        self.layer.addSublayer(progressBar)
    }
}
