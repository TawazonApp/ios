//
//  SeriesSessionHeaderTableViewCell.swift
//  Tawazon
//
//  Created by mac on 17/08/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SeriesSessionHeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var seriesDescriptionLabel: UILabel!
    @IBOutlet weak var verticalSeparatorView: GradientView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialize()
    }
    
    private func initialize(){
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        contentView.backgroundColor = .clear
        
        seriesDescriptionLabel.font = .kohinoorRegular(ofSize: 14)
        seriesDescriptionLabel.textColor = .white
        seriesDescriptionLabel.textAlignment = .center
        seriesDescriptionLabel.backgroundColor = .clear
        seriesDescriptionLabel.numberOfLines = 0
        seriesDescriptionLabel.lineBreakMode = .byWordWrapping
        
        verticalSeparatorView.backgroundColor = .clear
        verticalSeparatorView.applyGradientColor(colors: [UIColor.gulfBlue.cgColor, UIColor.waikawaGrey.withAlphaComponent(0).cgColor], startPoint: .bottom, endPoint: .top)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
