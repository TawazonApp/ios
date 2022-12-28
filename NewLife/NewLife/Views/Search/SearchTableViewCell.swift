//
//  SearchTableViewCell.swift
//  Tawazon
//
//  Created by mac on 14/06/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var premiumIcon: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var languageImageView: UIImageView!
    
    var session: HomeSessionVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }

    func initialize(){
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        contentView.backgroundColor = .clear
        
        iconImage.layer.cornerRadius = 20
        iconImage.layer.masksToBounds = true
        iconImage.clipsToBounds = true
        iconImage.contentMode = .scaleAspectFill
        iconImage.backgroundColor = .clear
        
        titleLabel.font = .lbcBold(ofSize: 16.0)
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        durationLabel.font = .kacstPen(ofSize: 14.0)
        durationLabel.textColor = .white
        durationLabel.layer.opacity = 0.6
        
        languageImageView.contentMode = .center
        
    }
    
    func fillData()  {
        titleLabel.text = session.name
        durationLabel.text = session.durationString
        iconImage.image = nil
        if let imageUrl = session.imageUrl?.url {
            iconImage.af.setImage(withURL: imageUrl)
            iconImage.layer.cornerRadius = 20
            iconImage.layer.masksToBounds = true
        }
        
        premiumIcon.image = nil
        premiumIcon.image = session.isLock ? UIImage(named: "SessionLock") : nil
       
        if session?.session?.type != SessionType.music.rawValue{
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
