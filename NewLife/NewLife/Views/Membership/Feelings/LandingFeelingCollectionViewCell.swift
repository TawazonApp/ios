//
//  LandingFeelingCollectionViewCell.swift
//  Tawazon
//
//  Created by mac on 03/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class LandingFeelingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var feelingTitle: UILabel!
    @IBOutlet weak var feelingIcon: UIImageView!
    
    var feeling: FeelCellModel?{
        didSet{
            fillData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        fillData()
    }
    private func initialize() {
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        backgroundContentView.backgroundColor = .white.withAlphaComponent(0.08)
        backgroundContentView.layer.cornerRadius = 20
        
        
        feelingTitle.font = .munaFont(ofSize: 22)
        feelingTitle.textColor = .white
//        feelingTitle.textAlignment = .center
//        feelingTitle.lineBreakMode = .byWordWrapping
//        feelingTitle.numberOfLines = 0
        
        feelingIcon.backgroundColor = .clear
        feelingIcon.contentMode = .scaleAspectFill
    }
    
    private func fillData(){
        feelingTitle.text = feeling?.name
        setSelectedStyle(feeling?.isSelected ?? false)
        
        feelingIcon.image = nil
        if let imageUrl = feeling?.icon?.url {
            feelingIcon.af.setImage(withURL: imageUrl, completion:  { (_) in
            })
        }
    }
    
    func setSelectedStyle( _ selected: Bool){
        // if selected style
        backgroundContentView.layoutIfNeeded()
        if selected{
            backgroundContentView.backgroundColor = .lightSkyBlue.withAlphaComponent(0.4)
            backgroundContentView.gradientBorder(width: 1, colors:  [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .left, endPoint: .right, andRoundCornersWithRadius: 17)
        }else{
            backgroundContentView.backgroundColor = .white.withAlphaComponent(0.08)
            backgroundContentView.layer.cornerRadius = 20
            backgroundContentView.layer.sublayers?.first(where: {$0.name == UIView.kLayerNameGradientBorder})?.removeFromSuperlayer()
        }
        
    }
}
