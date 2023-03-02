//
//  TawazonTalkSessionCollectionViewCell.swift
//  Tawazon
//
//  Created by mac on 18/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class TawazonTalkSessionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sessionImage: UIImageView!
    @IBOutlet weak var sessionTitleLabel: UILabel!
    @IBOutlet weak var sessionDurationLabel: UILabel!
    
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var languageImageView: UIImageView!
    
    @IBOutlet weak var comingSoonLockImageView: UIImageView!
    var session: HomeSessionVM? {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize(){
        self.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        
        sessionImage.layer.cornerRadius = 24
        sessionImage.contentMode = .scaleAspectFill
        sessionImage.clipsToBounds = true
        sessionImage.backgroundColor = .clear
        
        sessionTitleLabel.font = .munaBlackFont(ofSize: 17)
        sessionTitleLabel.textColor = .white
        sessionTitleLabel.numberOfLines = 0
        sessionTitleLabel.lineBreakMode = .byWordWrapping
        
        sessionDurationLabel.font = .kacstPen(ofSize: 14)
        sessionDurationLabel.textColor = .white.withAlphaComponent(0.72)
//        sessionDurationLabel should have attributed text for num and text
        
        lockImageView.contentMode = .center
        lockImageView.clipsToBounds = false
        lockImageView.image = #imageLiteral(resourceName: "SessionLock.pdf")
        
        languageImageView.contentMode = .center
        languageImageView.clipsToBounds = false
        
        comingSoonLockImageView.backgroundColor = .black.withAlphaComponent(0.47)
        comingSoonLockImageView.image = Language.language == .arabic ? UIImage(named: "ComingSoonIconAr") : UIImage(named: "ComingSoonIconEn")
        comingSoonLockImageView.layer.cornerRadius = 10
        comingSoonLockImageView.contentMode = .center
        comingSoonLockImageView.isHidden = true
    }
    
    private func fillData(){
        sessionImage.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        sessionImage.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: sessionImage.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: sessionImage.centerYAnchor).isActive = true
        loadingIndicator.center = sessionImage.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = session?.imageUrl?.url {
            sessionImage.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
            
        }
        
        sessionTitleLabel.text = session?.name
        sessionDurationLabel.text = session?.durationString
        
        lockImageView.isHidden = !(session?.isLock ?? false)
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
        
        if let comingSoonData = session?.session?.locked, comingSoonData{
            comingSoonLockImageView.isHidden = false
            if let imageUrl = session?.session?.thumbnailLockedUrl?.url {
                sessionImage.af.setImage(withURL: imageUrl, completion:  { (_) in
                    loadingIndicator.stopAnimating()
                    loadingIndicator.removeFromSuperview()
                })
            }
        }else{
            if let imageUrl = session?.imageUrl?.url {
                sessionImage.af.setImage(withURL: imageUrl, completion:  { (_) in
                    loadingIndicator.stopAnimating()
                    loadingIndicator.removeFromSuperview()
                })
                
            }
        }
    }
}
