//
//  TawazonTalkMainSessionView.swift
//  Tawazon
//
//  Created by mac on 18/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
import UIKit

protocol MainSessionViewDelegate: class {
    func playSession(session: SessionModel)
}
class TawazonTalkMainSessionView: UIView{
    @IBOutlet weak var mainTalkSessionTriangleView: TriangleView!
    @IBOutlet weak var mainTalkSessionTriangleBlurView: UIVisualEffectView!
    @IBOutlet weak var mainSessionTitleLabel: UILabel!
    @IBOutlet weak var mainSessionSubtitleLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var playButton: GradientButton!
    
    var delegate: MainSessionViewDelegate?
    
    var tawazonTalkVM: TawazonTalkVM?{
        didSet{
            setData()
        }
    }
    
    var talkItem: ItemVM?{
        didSet{
            print("didSet")
            initializeValues()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize(){
        self.backgroundColor = .clear
        self.layer.cornerRadius = 32
        
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
        playButton.imageView?.contentMode = .scaleAspectFill
        playButton.tintColor = .white
        playButton.layer.cornerRadius = playButton.frame.height/2
        playButton.applyGradientColor(colors: [UIColor.cyprus.cgColor, UIColor(hex6: UInt32(String(("#D9D9D9".dropFirst(1))), radix: 16) ?? 000000).cgColor], startPoint: .right, endPoint: .left)
        
        
    }
    
    private func initializeValues() {
        mainSessionTitleLabel.text = talkItem?.title
        mainSessionSubtitleLabel.text = talkItem?.content
        
        authorImageView.image = nil
        
        if let imageUrl = talkItem?.author?.image?.url {
            authorImageView.af.setImage(withURL: imageUrl, completion:  { (_) in
            })
        }
        authorNameLabel.text = talkItem?.author?.name
        playButton.applyGradientColor(colors: [UIColor(hex6: UInt32(String(((talkItem?.paletteColor?.dropFirst(1))!)), radix: 16) ?? 111111).cgColor, UIColor(hex6: UInt32(String(((talkItem?.paletteColor?.dropFirst(1))!)), radix: 16) ?? 111111).cgColor, UIColor(hex6: UInt32(String(("#D9D9D9".dropFirst(1))), radix: 16) ?? 000000).cgColor], startPoint: .bottomLeft, endPoint: .topRight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainTalkSessionTriangleBlurView.mask = mainTalkSessionTriangleView
        if #available(iOS 13.0, *) {
            mainTalkSessionTriangleBlurView.effect = UIBlurEffect(style: .systemThinMaterialDark)
        } else {
            // Fallback on earlier versions
            mainTalkSessionTriangleBlurView.effect = UIBlurEffect(style: .dark)
        }
    }
    
    private func setData() {
        mainSessionTitleLabel.text = tawazonTalkVM?.title
        mainSessionSubtitleLabel.text = tawazonTalkVM?.content
        
        authorImageView.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: authorImageView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: authorImageView.centerYAnchor).isActive = true
        loadingIndicator.center = authorImageView.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = tawazonTalkVM?.author?.image?.url {
            authorImageView.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
        }
        authorNameLabel.text = tawazonTalkVM?.author?.name
        playButton.applyGradientColor(colors: [UIColor(hex6: UInt32(String(((tawazonTalkVM?.paletteColor?.dropFirst(1))!)), radix: 16) ?? 111111).cgColor, UIColor(hex6: UInt32(String(((tawazonTalkVM?.paletteColor?.dropFirst(1))!)), radix: 16) ?? 111111).cgColor, UIColor(hex6: UInt32(String(("#D9D9D9".dropFirst(1))), radix: 16) ?? 000000).cgColor], startPoint: .bottomLeft, endPoint: .topRight)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton){
        if let session = tawazonTalkVM?.mainItem{
            delegate?.playSession(session: session)
        }
        
    }
}
