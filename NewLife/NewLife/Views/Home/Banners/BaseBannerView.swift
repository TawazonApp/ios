//
//  BaseBannerView.swift
//  Tawazon
//
//  Created by mac on 12/04/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol HomeTableBannerCellDelegate: class {
    func purchaseTapped()
    func moreTapped()
}

class BaseBannerView: UIView {

    weak var viewDelegate: HomeTableBannerCellDelegate?
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        
        initialize()
    }
    
    
    func initialize() {
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
    }

    @IBAction func purchaseButtonTapped(_ sender: Any) {
        viewDelegate?.purchaseTapped()
    }
    @IBAction func moreButtonTapped(_ sender: Any) {
        viewDelegate?.moreTapped()
    }
}
