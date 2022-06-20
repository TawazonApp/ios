//
//  SearchTableViewCell.swift
//  Tawazon
//
//  Created by mac on 14/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }

    func initialize(){
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        iconImage.layer.cornerRadius = 20
        iconImage.contentMode = .scaleAspectFit
        iconImage.backgroundColor = .clear
        
        titleLabel.font = .lbcBold(ofSize: 16.0)
        titleLabel.textColor = .white
        
        durationLabel.font = .kacstPen(ofSize: 14.0)
        durationLabel.textColor = .white
        durationLabel.layer.opacity = 0.6
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
