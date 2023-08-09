//
//  MoreStatsCell.swift
//  Tawazon
//
//  Created by mac on 17/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class MoreStatsCell: MoreCell {

    @IBOutlet weak var statsImageView: UIImageView!
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
        
        statsImageView.contentMode = .scaleAspectFill
        statsImageView.clipsToBounds = false
        
    }

    override func fillData() {
       super.fillData()
        statsImageView.image = (data.bgImageName != nil) ? UIImage(named: data.bgImageName!) : nil
       
   }
}
