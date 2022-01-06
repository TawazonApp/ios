//
//  CircularButton.swift
//  Tawazon
//
//  Created by Shadi on 23/05/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class CircularButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        tintColor = UIColor.white
        layer.cornerRadius = frame.height/2
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
}
