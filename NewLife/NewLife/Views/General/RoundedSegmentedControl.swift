//
//  RoundedSegmentedControl.swift
//  Tawazon
//
//  Created by mac on 26/01/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class RoundedSegmentedControl: UISegmentedControl {

     var segmentInset: CGFloat = 5
     var segmentImage: UIImage? = UIImage(color: .white)

    override func layoutSubviews(){
        super.layoutSubviews()

        //background
        layer.cornerRadius = (bounds.height - 6)/2
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = (foregroundImageView.bounds.height - 6)/2
        }
    }

}
