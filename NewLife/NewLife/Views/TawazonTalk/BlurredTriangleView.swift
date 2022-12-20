//
//  BlurredTriangleView.swift
//  Tawazon
//
//  Created by mac on 19/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class BlurredTriangleView: UIVisualEffectView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        print("DRAW BlurredTriangleView")
        TawazonTalkTriangle.drawCanvas1(frame: self.frame)
    }
    

}
