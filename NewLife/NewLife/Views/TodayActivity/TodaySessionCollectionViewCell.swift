//
//  TodaySessionCollectionViewCell.swift
//  Tawazon
//
//  Created by mac on 23/11/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TodaySessionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: GradientView!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var languageImageView: UIImageView!
    
    var session: HomeSessionVM? {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViewsBorders()
    }
    
    private func initialize() {
        self.layer.cornerRadius = 24.0
        
        cellView.backgroundColor = .gulfBlue.withAlphaComponent(0.4)
//        cellView.roundCorners(corners: .allCorners, radius: 24)
//        cellView.layer.cornerRadius = 24.0
//        cellView.layer.masksToBounds = false
//        cellView.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .topRight, endPoint: .bottom, andRoundCornersWithRadius: 24.0)
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.duskTwo
        
        overlayView.applyGradientColor(colors: [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.56).cgColor], startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
        
        lockImageView.contentMode = .center
        lockImageView.image = #imageLiteral(resourceName: "SessionLock.pdf")
        
        nameLabel.font = UIFont.lbcBold(ofSize: 16)
        nameLabel.textColor = UIColor.white
        
        durationLabel.font = UIFont.lbc(ofSize: 14)
        durationLabel.textColor = UIColor.white
        
        languageImageView.contentMode = .center
    }
    
    private func updateViewsBorders(){
        overlayView.layoutIfNeeded()
        overlayView.applyGradientColor(colors: [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.56).cgColor], startPoint: GradientPoint.top, endPoint: GradientPoint.bottom)
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
        if(session?.audioSources?.count ?? 0 > 1){
            languageImageView.image = UIImage(named: "SessionArEn")
        }else{
            if session?.audioSources?[0].code.lowercased() == "ar"{
                languageImageView.image = UIImage(named: "SessionAr")
            }else{
                languageImageView.image = UIImage(named: "SessionEn")
            }
        }
    }
}
