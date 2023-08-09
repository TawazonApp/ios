//
//  MoreArrowCell.swift
//  NewLife
//
//  Created by Shadi on 28/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MoreArrowCell: MoreCell {

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
        contentBodyView.layer.cornerRadius = 24
    }
    
}
