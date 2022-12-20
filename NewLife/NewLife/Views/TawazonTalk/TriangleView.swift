//
//  TriangleView.swift
//  Tawazon
//
//  Created by mac on 19/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TriangleView: UIView {

    override func draw(_ rect: CGRect) {
//        if #available(iOS 13.0, *) {
//            self.addBlurredBackground(style: .systemThinMaterialDark)
//        } else {
//            // Fallback on earlier versions
//            self.addBlurredBackground(style: .dark)
//        }
        TawazonTalkTriangle.drawCanvas1(frame: self.frame)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

