//
//  NewFeatureAnnouncementViewController.swift
//  Tawazon
//
//  Created by mac on 27/12/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit

protocol NewFeatureAnnouncementDelegate: class {
    func submitButtonTapped(feature: PremiumPage)
}

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
    
    var data: PremiumPage?
    
    var delegate: NewFeatureAnnouncementDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        fillData()
        
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
        featureLogo.contentMode = .scaleAspectFit
        featureLogo.clipsToBounds = true
        
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

    private func fillData(){
        guard let data = data else{
            return
        }
        
        newLabel.text = data.title
        
        featureImageView.image = nil
        let loadingIndicator = UIActivityIndicatorView(style: .white)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        featureImageView.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: featureImageView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: featureImageView.centerYAnchor).isActive = true
        loadingIndicator.center = featureImageView.center
        loadingIndicator.startAnimating()
        
        if let imageUrl = data.image?.url {
            featureImageView.af.setImage(withURL: imageUrl, completion:  { (_) in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
        }
        
        featureTitle.text = data.featureTitle
        contentLabel.text = data.content
        noteLabel.text = data.subtitle
        
        submitButton.setTitle(data.continueLabel, for: .normal)
        
    }
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton){
        submitInteract()
        self.dismiss(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton){
        if let feature = data{
            delegate?.submitButtonTapped(feature: feature)
            submitInteract()
            self.dismiss(animated: true)
        }
        
    }
    
    private func submitInteract(){
        if let featureId = data?.id{
            HomeServiceFactory.service().submitNewFeatureInteract(featureId: featureId){
                error in
            }
        }
        
    }
}

extension NewFeatureAnnouncementViewController{
    class func instatiate(data: PremiumPage) -> NewFeatureAnnouncementViewController{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: NewFeatureAnnouncementViewController.identifier) as! NewFeatureAnnouncementViewController
        viewController.data = data
        return viewController
    }
}
