//
//  CategorySummaryView.swift
//  NewLife
//
//  Created by Shadi on 27/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class CategorySummaryView: UIView {
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    var category: CategoryVM! {
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
        summaryLabel.font = UIFont.kacstPen(ofSize: 16)
        summaryLabel.textColor = UIColor.white
    }
    
    private func fillData() {
       summaryLabel.text = category.summary
    }
}
