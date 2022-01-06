//
//  SoundEffectsVolumeView.swift
//  NewLife
//
//  Created by Shadi on 16/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol SoundEffectsVolumeViewDelegate: class {
    func voulmeChanged(volume: Double)
}

class SoundEffectsVolumeView: UIView {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var upImageView: UIImageView!
    @IBOutlet weak var downImageView: UIImageView!
    
    weak var delegate: SoundEffectsVolumeViewDelegate?
    
    var volume: Double {
        return Double(slider.value)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    private func initialize() {
        slider.tintColor = UIColor.white
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.24)
        slider.minimumTrackTintColor = UIColor.white
        
        upImageView.image = #imageLiteral(resourceName: "VolumeUp.pdf") .flipIfNeeded
        downImageView.image = #imageLiteral(resourceName: "VolumeDown.pdf") .flipIfNeeded
        
    }
    
   
    func setVolume(volume: Double) {
        slider.setValue(Float(volume), animated: false)
    }
    
    @IBAction func sliderChanged(_ slider: UISlider) {
        delegate?.voulmeChanged(volume: Double(slider.value))
    }

}
