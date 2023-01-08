//
//  SelfSizingCollectionView.swift
//  Tawazon
//
//  Created by mac on 08/01/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class SelfSizingCollectionView: UICollectionView {

    override var contentSize: CGSize{
        didSet {
            if oldValue.height != self.contentSize.height {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: contentSize.height)
    }

}
