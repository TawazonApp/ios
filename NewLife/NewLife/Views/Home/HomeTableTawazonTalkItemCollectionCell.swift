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
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var frameComponent1: UIImageView!
    @IBOutlet weak var frameComponent2: UIImageView!
    @IBOutlet weak var itemImageViewMask: UIImageView!
    
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customLayout()
    }
    
    private func customLayout(){
        itemImageViewMask.layoutIfNeeded()
        itemImageView.layoutIfNeeded()
        itemImageViewMask.frame = itemImageView.bounds
        itemImageView.mask = itemImageViewMask
    }
    private func initialize() {
        self.layer.cornerRadius = 32
        self.layer.masksToBounds = true
        
        gradientView.layer.cornerRadius = 32
        gradientView.clipsToBounds = true
        gradientView.applyGradientColor(colors: [UIColor.cyprus.cgColor, UIColor(hex6: UInt32(String(("#D9D9D9".dropFirst(1))), radix: 16) ?? 000000).cgColor], startPoint: .left, endPoint: .right)
        
        itemImageViewMask.image = UIImage(named: "TawazonTalkItemMask")
        itemImageViewMask.contentMode = .scaleAspectFill
        itemImageViewMask.backgroundColor = .clear
        
        frameComponent1.image = UIImage(named: "TawazonTalkFrameComp1")
        frameComponent1.contentMode = .scaleAspectFill
        
        frameComponent2.image = UIImage(named: "TawazonTalkFrameComp2")
        frameComponent2.contentMode = .scaleAspectFill
        
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.backgroundColor = .yellow
//        itemImageView.isHidden = true
        
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
                self.customLayout()
                self.itemImageView.backgroundColor = .yellow
            })
            
        }
        
        itemTitleLabel.text = item?.title
        itemContentLabel.text = item?.content
        
        gradientView.applyGradientColor(colors: [UIColor(hex6: UInt32(String(((item?.paletteColor?.dropFirst(1))!)), radix: 16) ?? 111111).cgColor, UIColor(hex6: UInt32(String(((item?.paletteColor?.dropFirst(1))!)), radix: 16) ?? 111111).cgColor,  UIColor(hex6: UInt32(String(("#D9D9D9".dropFirst(1))), radix: 16) ?? 000000).cgColor], startPoint: Language.language == .arabic ? .right : .left, endPoint: Language.language == .arabic ? .left : .right)
        
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
