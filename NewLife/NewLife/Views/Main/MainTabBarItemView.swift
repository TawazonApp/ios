//
//  MainTabBarItemView.swift
//  NewLife
//
//  Created by Shadi on 26/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol MainTabBarItemViewDelegate: class {
    func itemTapped(item: MainTabBarItemVM)
}

class MainTabBarItemView: UIView {
    
    @IBOutlet weak var imageView: GradientImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: MainTabBarItemViewDelegate?
    
    var data: MainTabBarItemVM? {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds  = true
        imageView.contentMode = .center
        
        titleLabel.font = UIFont.kacstPen(ofSize: 16)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 2
        
        backgroundColor = UIColor.clear
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
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
            imageView.applyGradientColor(colors: colors, startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        } else {
            imageView.applyGradientColor(colors: [UIColor.clear.cgColor, UIColor.clear.cgColor], startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        }
        
    }
    
    private func fillData() {
        titleLabel.text = data?.title
        imageView.image = UIImage(named: data?.imageName ?? "")
        updateStyle(isSelected: data?.isSelected ?? false)
    }

}
