//
//  TopTabBarItemView.swift
//  Tawazon
//
//  Created by mac on 02/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol TopTabBarItemViewDelegate: class {
    func itemTapped(item: TopTabBarItemVM)
}

class TopTabBarItemView: UIView {

    @IBOutlet weak var backgroundView: GradientView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: TopTabBarItemViewDelegate?
    
    var data: TopTabBarItemVM? {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        backgroundView.layer.cornerRadius = 14
        backgroundView.layer.masksToBounds  = true
        backgroundView.contentMode = .scaleToFill
        
        backgroundImage.layer.cornerRadius = 14
        backgroundImage.layer.masksToBounds = true
        backgroundImage.contentMode = .center
        
        titleLabel.font = UIFont.lbc(ofSize: 16)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 2
        
        backgroundColor = UIColor.clear
        backgroundView.backgroundColor = UIColor.midnightExpress.withAlphaComponent(0.56)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
    }
    
    @objc func tapped(_ sender:  UITapGestureRecognizer) {
        guard let data = data else { return }
        data.isSelected = true
        updateStyle(isSelected: data.isSelected)
        delegate?.itemTapped(item: data)
    }
    
    func updateStyle(isSelected: Bool) {
        data?.isSelected = isSelected
        guard let colors = data?.gradientColors else { return }
        if isSelected {
            backgroundView.applyGradientColor(colors: colors, startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
            self.backgroundImage.isHidden = false
        } else {
            backgroundView.applyGradientColor(colors: [UIColor.midnightExpress.cgColor], startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
            self.backgroundImage.isHidden = true
        }
        
    }
    
    private func fillData() {
        titleLabel.text = data?.title
        categoryImage.image = UIImage(named: data?.imageName ?? "")
        backgroundImage.image = UIImage(named: data?.backgroundImage ?? "")
        updateStyle(isSelected: data?.isSelected ?? false)
    }

}
