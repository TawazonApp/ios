//
//  HomeTableSessionCollectionCell.swift
//  Tawazon
//
//  Created by Shadi on 14/11/2020.
//  Copyright © 2020 Inceptiontech. All rights reserved.
//

import UIKit

class HomeTableSessionCollectionCell: UICollectionViewCell {
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var session: HomeSessionVM? {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        self.layer.cornerRadius = 32
        self.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.duskTwo
        lockImageView.contentMode = .center
        lockImageView.image = #imageLiteral(resourceName: "SessionLock.pdf")
        
        nameLabel.font = UIFont.lbcBold(ofSize: 16)
        nameLabel.textColor = UIColor.white
        
        durationLabel.font = UIFont.lbc(ofSize: 14)
        durationLabel.textColor = UIColor.white
    }
    
    private func fillData() {
        
        imageView.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        loadingIndicator.center = imageView.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = session?.imageUrl?.url {
            imageView.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
            
        }
        
        nameLabel.text = session?.name
        durationLabel.text = session?.durationString
        
        lockImageView.isHidden = !(session?.isLock ?? false)
    }
}
