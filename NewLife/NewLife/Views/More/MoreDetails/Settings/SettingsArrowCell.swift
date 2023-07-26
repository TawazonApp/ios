//
//  SettingsArrowCell.swift
//  Tawazon
//
//  Created by mac on 18/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class SettingsArrowCell: SettingsCell {

    @IBOutlet weak var arrowImageview: UIImageView!
    @IBOutlet weak var contentBodyView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        arrowImageview.image = #imageLiteral(resourceName: "CellArrow.pdf").flipIfNeeded

        contentBodyView.backgroundColor = .black.withAlphaComponent(0.6)
        contentBodyView.roundCorners(corners: .allCorners, radius: 24)
    }
    
}
