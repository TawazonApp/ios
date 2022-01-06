//
//  RamdanPremiumDiscountCell.swift
//  Tawazon
//
//  Created by Shadi on 09/04/2021.
//  Copyright © 2021 Inceptiontech. All rights reserved.
//

import UIKit

class RamdanPremiumDiscountCell: UITableViewCell {
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
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
        subTitleLabel.font = UIFont.sanaFont(ofSize: 28)
        subTitleLabel.textColor = .duskBlue
        discountLabel.font = UIFont.kohinoorRegular(ofSize: 18)
        discountLabel.textColor = .duskBlue
    }
    
    private func populateData() {
        let stackLabelStrings = ["ramdanDiscountFeature1".localized, "ramdanDiscountFeature2".localized]
        var index = 0
        for view in stackLabels.arrangedSubviews {
            if let label = view.subviews.first(where: { $0 is UILabel }) as? UILabel {
                label.text = stackLabelStrings[safe: index] ?? ""
            }
            index += 1
        }
    }
}

