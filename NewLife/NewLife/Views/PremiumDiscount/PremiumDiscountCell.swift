//
//  PremiumDiscountCell.swift
//  Tawazon
//
//  Created by Shadi on 14/12/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class PremiumDiscountCell: UITableViewCell {
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var stackLabels: UIStackView!

    var percentageTitle: String = "" {
        didSet {
            discountLabel.text = percentageTitle
        }
    }
    
    var subTitle: String = "" {
        didSet {
            subTitleLabel.text = subTitle
            populateData()
        }
    }
    var imageUrl: String? {
        didSet {
            if let imageUrl = imageUrl?.url {
                iconImageView?.af.setImage(withURL: imageUrl)
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.white
        backgroundColor = UIColor.white
    }
    
    private func populateData() {
        let stackLabelStrings = ["normalDiscountFeature1".localized, "normalDiscountFeature2".localized, "normalDiscountFeature3".localized]
        var index = 0
        for view in stackLabels.arrangedSubviews {
            if let label = view.subviews.first(where: { $0 is UILabel }) as? UILabel {
                label.text = stackLabelStrings[safe: index] ?? ""
            }
            index += 1
        }
    }
}
