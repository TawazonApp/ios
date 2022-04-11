//
//  Premium1FeaturesTableViewCell.swift
//  Tawazon
//
//  Created by mac on 23/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class Premium1FeaturesTableViewCell: UITableViewCell {

    @IBOutlet weak var bulletImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
    
    private func initialize() {
        bulletImage.image = UIImage(named: "Premium1Bullet")
        
        itemLabel.font = UIFont.munaFont(ofSize: 16.0)
        itemLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
