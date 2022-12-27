//
//  HomeTableTawazonTalkItemCollectionCell.swift
//  Tawazon
//
//  Created by mac on 26/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class HomeTableTawazonTalkItemCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemContentLabel: UILabel!
    
    var item: ItemVM? {
        didSet {
            print("didSet")
            fillData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        initialize()
    }
    
    private func initialize() {
        self.layer.cornerRadius = 32
        self.layer.masksToBounds = true
        
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.backgroundColor = .clear
        itemImageView.layer.cornerRadius = 32
        
        itemTitleLabel.font = UIFont.munaBoldFont(ofSize: 24)
        itemTitleLabel.textColor = UIColor.white
        
        itemContentLabel.font = UIFont.munaFont(ofSize: 16)
        itemContentLabel.textColor = UIColor.white
        itemContentLabel.numberOfLines = 0
        itemContentLabel.lineBreakMode = .byWordWrapping
        
    }
    
    private func fillData() {
        print("fillData: \(item?.title)")
        itemImageView.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: itemImageView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: itemImageView.centerYAnchor).isActive = true
        loadingIndicator.center = itemImageView.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = item?.image?.url {
            itemImageView.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
            
        }
        
        itemTitleLabel.text = item?.title
        itemContentLabel.text = item?.content
        
        
//        lockImageView.isHidden = !(session?.isLock ?? false)
//        if session?.session?.type != SessionType.music.rawValue{
//            if(session?.audioSources?.count ?? 0 > 1){
//                languageImageView.image = UIImage(named: "SessionArEn")
//            }else{
//                if session?.audioSources?[0].code.lowercased() == "ar"{
//                    languageImageView.image = UIImage(named: "SessionAr")
//                }else{
//                    languageImageView.image = UIImage(named: "SessionEn")
//                }
//            }
//        }
    }
}
