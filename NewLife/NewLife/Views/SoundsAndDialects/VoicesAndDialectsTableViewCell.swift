//
//  VoicesAndDialectsTableViewCell.swift
//  Tawazon
//
//  Created by mac on 31/05/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class VoicesAndDialectsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }

    private func initialize(){
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        self.selectionStyle = .none
        
        self.accessoryType = .none
        
        titleLabel.font = UIFont.munaFont(ofSize: 22.0)
        titleLabel.textColor = .white
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 28.0, y: self.frame.height - 1, width: contentView.frame.size.width - 56.0, height: 1.0)
        bottomBorder.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        self.layer.addSublayer(bottomBorder)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setSelectedStyle(selected: Bool) {
        if selected {
            titleLabel.font = UIFont.munaBoldFont(ofSize: 22.0)
            self.accessoryType = .checkmark
        }else{
            titleLabel.font = UIFont.munaFont(ofSize: 22.0)
            self.accessoryType = .none
        }
    }

}
