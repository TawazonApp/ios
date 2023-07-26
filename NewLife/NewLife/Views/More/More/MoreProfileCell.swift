//
//  MoreProfileCell.swift
//  Tawazon
//
//  Created by mac on 13/07/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit

class MoreProfileCell: UITableViewCell {

    @IBOutlet weak var contentBodyView: UIView!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var arrowImageview: UIImageView!
    @IBOutlet weak var dividerView: UIView!
    
    var data: MoreCellVM! {
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
        updateViews()
    }
    
    private func initialize() {
        backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        premiumLabel.roundCorners(corners: .allCorners, radius: 8)
        premiumLabel.backgroundColor = .lavenderBlue
        premiumLabel.font = .munaFont(ofSize: 13)
        premiumLabel.textColor = .black
        premiumLabel.textAlignment = .center
        premiumLabel.isHidden = !(UserInfoManager.shared.getUserInfo()?.isPremium() ?? false)
        premiumLabel.text = "moreProfilePremiumLabel".localized
        
        arrowImageview.image = #imageLiteral(resourceName: "CellArrow.pdf").flipIfNeeded
    
        contentBodyView.backgroundColor = .black.withAlphaComponent(0.6)
        contentBodyView.roundCorners(corners: .allCorners, radius: 24)
        
        nameLabel.font = UIFont.munaBoldFont(ofSize: 24)
        nameLabel.textColor = UIColor.white
        
        emailLabel.font = UIFont.kacstPen(ofSize: 13)
        emailLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        
        subTitleLabel.font = UIFont.munaFont(ofSize: 20)
        subTitleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        
        dividerView.backgroundColor = .white.withAlphaComponent(0.12)
        
    }
    
     func fillData() {
        iconImageView.image = (data.imageName != nil) ? UIImage(named: data.imageName!) : nil
        
        nameLabel.text = data.title
        emailLabel.text = data.detailedTitle
         subTitleLabel.text = data.subTitle
    }
    
    func updateViews(){
        premiumLabel.roundCorners(corners: .allCorners, radius: 8)
    }

}
