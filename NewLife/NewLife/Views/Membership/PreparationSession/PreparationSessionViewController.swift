//
//  PreparationSessionViewController.swift
//  Tawazon
//
//  Created by mac on 31/10/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import UIKit
import AudioToolbox

class PreparationSessionViewController: HandleErrorViewController {

    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var skipButton: CircularButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var sessionImageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var startButton: GradientButton!
    
    var session: SessionVM? {
        return SessionPlayerMananger.shared.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
print("PreparationSessionViewController")
        initialize()
        fetchData()
    }
    
    private func initialize(){
        view.backgroundColor = .midnight
        
        backgroundImageView.backgroundColor = .clear
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "PreparationSessionHeader")
        
        logoImageView.backgroundColor = .clear
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true
        logoImageView.image = UIImage(named: "tawazonLogoGlyph")
        
        skipButton.roundCorners(corners: .allCorners, radius: 24)
        skipButton.backgroundColor = .black.withAlphaComponent(0.62)
        skipButton.setImage(UIImage(named: "Cancel"), for: .normal)
        skipButton.tintColor = .white
        
        titleLabel.font = .munaFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "preparationSessionViewTitle".localized
        
        
        subtitleLabel.font = .munaBoldFont(ofSize: 20)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "preparationSessionViewSubtitle".localized
        
        sessionImageView.backgroundColor = .clear
        sessionImageView.contentMode = .scaleAspectFill
        sessionImageView.clipsToBounds = true
        sessionImageView.layer.cornerRadius = sessionImageView.frame.width / 2
        
        print("sessionImageView.frame.width / 2: \(sessionImageView.frame.width), \(sessionImageView.frame.width / 2)")
        
        sessionImageView.layer.borderColor = UIColor.mediumPurple.cgColor
        sessionImageView.layer.borderWidth = 1
        
        noteLabel.font = .munaFont(ofSize: 14)
        noteLabel.textColor = .white
        noteLabel.textAlignment = .center
        noteLabel.numberOfLines = 0
        noteLabel.lineBreakMode = .byWordWrapping
        noteLabel.text = "preparationSessionViewNote".localized
        
        startButton.tintColor = .white
        startButton.layer.cornerRadius = 20
        startButton.backgroundColor = .lightSkyBlue.withAlphaComponent(0.4)
        startButton.gradientBorder(width: 1, colors:  [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .right, endPoint: .left, andRoundCornersWithRadius: 17)
        startButton.setTitle("preparationSessionViewSubmitButtonTitle".localized, for: .normal)
        startButton.setImage(UIImage(named: "PreparationSessionPlay"), for: .normal)
        startButton.titleLabel?.font = UIFont.munaBoldFont(ofSize: 26)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startButton.gradientBorder(width: 1, colors: [.mayaBlue, .mauve, .white.withAlphaComponent(0)], startPoint: .right, endPoint: .left, andRoundCornersWithRadius: 17)
    }
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendStartPrepSkipped()
        openLandingFeelingsViewController()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        TrackerManager.shared.sendStartPrepFromButton()
        openPreparationSessionPlayerViewController()
    }
    
    private func openLandingFeelingsViewController(){
        let viewController = LandingFeelingsViewController.instantiate(skipped: true)
        viewController.modalPresentationStyle = .currentContext
        self.show(viewController, sender: self)
//        self.present(viewController, animated: false, completion: nil)
    }
    
    @objc private func openPreparationSessionPlayerViewController(){
        playMainBackgroundAudio()
        let viewController = PreparationSessionPlayerViewController.instantiate()
        viewController.modalPresentationStyle = .currentContext
        self.show(viewController, sender: self)
//        self.present(viewController, animated: false, completion: nil)
    }
    
    private func playMainBackgroundAudio() {
        if UserDefaults.userAppBackgroundSound() ?? true {
            BackgroundAudioManager.shared.mainBackgroundAudio.play()
        }else{
            BackgroundAudioManager.shared.mainBackgroundAudio.stop()
        }
        
    }
    
    @objc func sessionImageViewTapped(){
        TrackerManager.shared.sendStartPrepFromButton()
        openPreparationSessionPlayerViewController()
    }
    private func fetchData(){
        let sessionId = RemoteConfigManager.shared.string(forKey: .prepSessionId)
        SessionServiceFactory.service().fetchPreparationSessionInfo(sessionId: (sessionId)){ (sessionModel, error) in
            LoadingHud.shared.hide(animated: true)
            if let error = error{
                self.showErrorMessage(message: error.localizedDescription)
                return
            }
            if let sessionModel = sessionModel {
                SessionPlayerMananger.shared.session = SessionVM(service: SessionServiceFactory.service(), session: sessionModel)
                self.fillData()
            }
        }
    }
    
    private func fillData(){
        if let imageUrl = session?.imageUrl {
            sessionImageView.af.setImage(withURL: imageUrl, completion:  { (_) in
                self.sessionImageView.isUserInteractionEnabled = true
                self.sessionImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openPreparationSessionPlayerViewController)))
            })
        }
    }
}

extension PreparationSessionViewController{
    class func instantiate() -> PreparationSessionViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: PreparationSessionViewController.identifier) as! PreparationSessionViewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
