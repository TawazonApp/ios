//
//  MoreDetailsViewController.swift
//  NewLife
//
//  Created by Shadi on 05/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class MoreDetailsViewController: SoundEffectsPresenterViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var  backgroundImageName: String? {
        didSet {
            backgroundImageView.image = (backgroundImageName != nil) ? UIImage(named: backgroundImageName!) : nil
        }
    }
    
    override var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        self.view.layer.masksToBounds = true
        
        backgroundImageView.contentMode = .scaleAspectFill
        
        
        backButton.layer.cornerRadius = backButton.frame.height/2
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backButton.tintColor = UIColor.white
        let backImage = isModal() ?  #imageLiteral(resourceName: "Cancel.pdf") : #imageLiteral(resourceName: "BackArrow.pdf").flipIfNeeded
        backButton.setImage(backImage, for: .normal)
        
        titleLabel.font = UIFont.kacstPen(ofSize: 24)
        titleLabel.textColor = UIColor.white
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        SystemSoundID.play(sound: .Sound1)
        if isModal() {
            self.dismiss(animated: true, completion: nil)
        } else {
             self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}
