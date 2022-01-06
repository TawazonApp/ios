//
//  MembershipButtonCell.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class MembershipButtonCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var data: MembershipFormButtonCellVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor.black.withAlphaComponent(0.72)
        self.contentView.backgroundColor = UIColor.clear
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.kacstPen(ofSize: 22)
    }
    
    private func fillData() {
        titleLabel.text = data.title
    }
}
