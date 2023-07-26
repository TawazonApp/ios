//
//  SettingsAppVersionCell.swift
//  Tawazon
//
//  Created by mac on 18/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import Foundation

import UIKit

class SettingsAppVersionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var data: SettingsCellVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.kacstPen(ofSize: 20)
        titleLabel.textColor = UIColor.white
        
        subTitleLabel.font = UIFont.kacstPen(ofSize: 12)
        subTitleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        
    }
    
    func fillData() {
                
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
    }
}
