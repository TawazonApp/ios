//
//  NewFeatureAnnouncementViewController.swift
//  Tawazon
//
//  Created by mac on 27/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

class NewFeatureAnnouncementViewController: UIViewController {

    @IBOutlet weak var backgroundView: GradientView!
    
    @IBOutlet weak var gradientBlurView: GradientView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var featureImageView: UIImageView!
    @IBOutlet weak var featureLogo: UIImageView!
    @IBOutlet weak var featureTitle: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    

    private func initialize(){
        view.backgroundColor = .cyprus.withAlphaComponent(0.72)
        
        backgroundView.backgroundColor = .clear
        backgroundView.layer.cornerRadius = 24
        backgroundView.clipsToBounds = true
        backgroundView.gradientBorder(width: 0.5, colors: [.white.withAlphaComponent(0.59), .white.withAlphaComponent(0)], startPoint: .topRight, endPoint: .bottomLeft, andRoundCornersWithRadius: 24)
        
        gradientBlurView.applyGradientColor(colors: [UIColor.heliotropeTwo.withAlphaComponent(0.2).cgColor, UIColor.white.withAlphaComponent(0.2).cgColor, UIColor.white.withAlphaComponent(0.2).cgColor], startPoint: .topRight, endPoint: .bottomLeft)
        
        closeButton.setImage(UIImage(named: "Cancel"), for: .normal)
        closeButton.tintColor = .white
        
        newLabel.font = .munaFont(ofSize: 18)
        newLabel.textColor = .white
        newLabel.textAlignment = .center
        newLabel.text = "newText".localized
        
        featureImageView.backgroundColor = .clear
        featureImageView.contentMode  = .scaleAspectFill
        
        featureLogo.image = Language.language == .english ? UIImage(named: "TawazonTalkLogoEn") : UIImage(named: "TawazonTalkLogoAr")
        featureLogo.contentMode = .center
        featureLogo.clipsToBounds = false
        
        featureTitle.font = .munaBlackFont(ofSize: 20)
        featureTitle.textColor = .white
        featureTitle.text = "TawazonTalkHomeSectionTitle".localized
        
        contentLabel.font = .munaFont(ofSize: 18)
        contentLabel.textColor = .white
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        
        noteLabel.font = .munaBoldFont(ofSize: 13)
        noteLabel.textColor = .white
        noteLabel.textAlignment = .center
        
        submitButton.backgroundColor = .black.withAlphaComponent(0.36)
        submitButton.layer.cornerRadius = 22
        submitButton.tintColor = .white
        submitButton.titleLabel?.font = .munaBoldFont(ofSize: 22)
    }

}

extension NewFeatureAnnouncementViewController{
    class func instatiate() -> NewFeatureAnnouncementViewController{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: NewFeatureAnnouncementViewController.identifier) as! NewFeatureAnnouncementViewController
        return viewController
    }
}
