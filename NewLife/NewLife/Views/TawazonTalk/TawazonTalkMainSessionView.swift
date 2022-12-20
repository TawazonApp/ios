//
//  TawazonTalkMainSessionView.swift
//  Tawazon
//
//  Created by mac on 18/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
import UIKit

class TawazonTalkMainSessionView: UIView{
    @IBOutlet weak var mainTalkSessionBGImageView: UIImageView!
    @IBOutlet weak var mainTalkSessionTriangleView: TriangleView!
    @IBOutlet weak var mainTalkSessionTriangleBlurView: UIVisualEffectView!
    @IBOutlet weak var mainSessionTitleLabel: UILabel!
    @IBOutlet weak var mainSessionSubtitleLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var playButton: CircularButton!
    
    var session: SessionModel?{
        didSet{
            setData()
        }
    }
    var color: String?{
        didSet{
            playButton.backgroundColor = UIColor(hex6: UInt32(String((color?.characters.dropFirst(1))!), radix: 16) ?? 111111)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        mainTalkSessionBGImageView.draw(mainTalkSessionBGImageView.frame)
//        TawazonTalkTriangle.drawCanvas1(frame: mainTalkSessionBGImageView.frame)
    }
    private func initialize(){
        mainTalkSessionBGImageView.backgroundColor = .clear
        mainTalkSessionBGImageView.contentMode = .scaleToFill
        mainTalkSessionBGImageView.isHidden = true
        
//        mainTalkSessionTriangleView.blurEffect(style: .dark)
        mainTalkSessionTriangleBlurView.mask = mainTalkSessionTriangleView
        if #available(iOS 13.0, *) {
            mainTalkSessionTriangleBlurView.effect = UIBlurEffect(style: .systemThinMaterialDark)
        } else {
            // Fallback on earlier versions
            mainTalkSessionTriangleBlurView.effect = UIBlurEffect(style: .dark)
        }
        
        mainSessionTitleLabel.font = .munaBoldFont(ofSize: 28)
        mainSessionTitleLabel.textColor = .white
        
        mainSessionSubtitleLabel.font = .munaFont(ofSize: 17)
        mainSessionSubtitleLabel.textColor = .white.withAlphaComponent(0.86)
        mainSessionSubtitleLabel.numberOfLines = 0
        mainSessionSubtitleLabel.lineBreakMode = .byWordWrapping
        
        authorImageView.layer.cornerRadius = 24
        authorImageView.backgroundColor = .clear
        authorImageView.contentMode = .scaleAspectFill
        
        authorLabel.font = .munaFont(ofSize: 16)
        authorLabel.textColor = .white.withAlphaComponent(0.86)
        authorLabel.text = "TawazonTalkAuthorLabel".localized
        
        authorNameLabel.font = .munaBoldFont(ofSize: 20)
        authorNameLabel.textColor = .white
        
        playButton.setImage(UIImage(named: "PreparationSessionPlay"), for: .normal)
        playButton.tintColor = .white
        playButton.backgroundColor = UIColor(hex6: 683434)
    }
    private func setData() {
        mainSessionTitleLabel.text = session?.name
        mainSessionSubtitleLabel.text = session?.descriptionString
        
        authorImageView.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: authorImageView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor).isActive = true
        loadingIndicator.center = authorImageView.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = session?.imageUrl?.url {
            authorImageView.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
            
        }
        
        authorNameLabel.text = session?.artist?.name
        
    }
}
