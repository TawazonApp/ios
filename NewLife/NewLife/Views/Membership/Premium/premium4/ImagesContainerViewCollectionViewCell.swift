//
//  ImagesPremium4CollectionViewCell.swift
//  Tawazon
//
//  Created by mac on 20/03/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class ImagesContainerViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var separatorView: GradientView!
    @IBOutlet weak var caption: UILabel!
    
    var imageData : FeatureItem!{
        didSet{
            setData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        caption.font = UIFont.munaFont(ofSize: 20)
        
        separatorView.applyGradientColor(colors: [UIColor.veniceBlue.withAlphaComponent(0.0).cgColor, UIColor.veniceBlue.withAlphaComponent(0.71).cgColor, UIColor.veniceBlue.cgColor], startPoint: .top, endPoint: .bottom)
    }
    
    private func setData(){
        if let imagePath = imageData.image{
            imageView.af.setImage(withURL: imagePath.url!)
        }
        
        caption.text = imageData.content
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
           
            setNeedsLayout()
            layoutIfNeeded()
           
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var frame = layoutAttributes.frame
            frame.size.height = ceil(size.height)
            layoutAttributes.frame = frame
           
            return layoutAttributes
        }
}
