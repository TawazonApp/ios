//
//  SoundEffectsCollectionCell.swift
//  NewLife
//
//  Created by Shadi on 04/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class SoundEffectsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playingIndicator: UIView!
    
    var audio: BackgroundAudioVM! {
        didSet {
            fillData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        
        self.layer.masksToBounds = false
        
        titleLabel.font = UIFont.kacstPen(ofSize: 16)
        titleLabel.textColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height/2
        
        playingIndicator.layer.cornerRadius = playingIndicator.frame.height/2
        playingIndicator.layer.applySketchShadow(color: UIColor.white, alpha: 1.0, x: 0, y: 0, blur: 12, spread: 0)
    }
    
    private func fillData() {
        titleLabel.text = audio.title
        imageView.image = UIImage(named: audio.imageName)
        stopPlayingAnimation(animated: false)
        if audio.playingStatus == BackgroundAudioVM.PlayingStatus.playing {
            animatePlayingIndicator()
        }
    }
    
   
    func startPlayingAnimation() {
        self.playingIndicator.isHidden = false
        self.playingIndicator.alpha = 0.0
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.playingIndicator.alpha = 1.0
            self?.playingIndicator.transform = CGAffineTransform(translationX: 5, y: -5)
        }) { [weak self] (finish) in
            self?.animatePlayingIndicator()
        }
    }
    
    private func animatePlayingIndicator() {
        self.playingIndicator.isHidden = false
        self.playingIndicator.alpha = 1.0
        
        self.playingIndicator.transform = CGAffineTransform(translationX: 5, y: -5)
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: { [weak self] in
            self?.playingIndicator.transform = CGAffineTransform(translationX: -5, y: 5)
        })
    }
    
    func stopPlayingAnimation(animated: Bool) {
        
        self.layer.removeAllAnimations()
        self.playingIndicator.transform = CGAffineTransform.identity
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                self?.playingIndicator.alpha = 0.0
            }) { [weak self] (finish) in
                self?.playingIndicator.isHidden = true
            }
            
        } else {
            self.playingIndicator.isHidden = true
        }
    }
}
