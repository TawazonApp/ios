//
//  OnboardingLanguageViewController.swift
//  Tawazon
//
//  Created by mac on 08/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//
import UserNotifications
import UIKit

class OnboardingLanguageViewController: UIViewController {

    @IBOutlet weak var topBannerBackground: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var descriptionArLabel: UILabel!
    @IBOutlet weak var descriptionEnLabel: UILabel!
    @IBOutlet weak var languagesStack: UIStackView!
    @IBOutlet weak var arabicButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.openLanguageScreen, payload: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func initialize(){
        self.view.backgroundColor = .darkBlueGreyThree
        
        topBannerBackground.image = UIImage(named: "OnboardingBackground")
        topBannerBackground.contentMode = .scaleAspectFill
        
        logoImageView.image = UIImage(named: "LogoWithName")
        
        sloganLabel.text = "launchSlogan".localized
        sloganLabel.font = .lbc(ofSize: 18)
        sloganLabel.textColor = .white
        
        descriptionArLabel.text = "بامكانك تغيير اللغة لاحقا"
        descriptionArLabel.font = .lbc(ofSize: 18)
        descriptionArLabel.textColor = .white
        
        descriptionEnLabel.text = "You can change the language later"
        descriptionEnLabel.font = .lbc(ofSize: 18)
        descriptionEnLabel.textColor = .white
        
        languagesStack.backgroundColor = .clear
        languagesStack.distribution = .fillEqually
        languagesStack.spacing = 12
        
        arabicButton.backgroundColor = .white
//        arabicButton.roundCorners(corners: .allCorners, radius: 18)
        arabicButton.layer.cornerRadius = 18
        arabicButton.tintColor = .black
        arabicButton.setTitle("عربي", for: .normal)
        arabicButton.titleLabel?.font = .munaFont(ofSize: 20)
        
        englishButton.backgroundColor = .white
//        englishButton.roundCorners(corners: .allCorners, radius: 18)
        englishButton.layer.cornerRadius = 18
        englishButton.tintColor = .black
        englishButton.setTitle("English", for: .normal)
        englishButton.titleLabel?.font = .munaFont(ofSize: 18)
        
    }
    
    @IBAction func arabicButtonTapped(_ sender: Any) {
        changeLanguage(language: .arabic)
    }
    
    @IBAction func englishButtonTapped(_ sender: Any) {
        changeLanguage(language: .english)
    }
    
    private func changeLanguage(language: Language) {
        TrackerManager.shared.sendEvent(name: GeneralCustomEvents.firstOpenSetAppLanguage, payload: ["language": language.rawValue])
        
        UserDefaults.appOpened()
        guard language != Language.language else {
            openWelcomeViewController()
//            NotificationCenter.default.post(name: Notification.Name.showOnboardingInstallSources, object: nil)
            return
        }
        Language.language = language
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        (UIApplication.shared.delegate as? AppDelegate)?.resetApp()
//        self.perform(#selector(showOnboardingInstallSources), with: nil, afterDelay: 3)
        
    }
    
    @objc private func showOnboardingInstallSources() {
        NotificationCenter.default.post(name: Notification.Name.showOnboardingInstallSources, object: nil)
    }
    
    private func openWelcomeViewController() {
        let viewController = WelecomeViewController.instantiate()
        viewController.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(viewController, animated: true)
//        self.present(viewController, animated: false, completion: nil)
    }
}
extension OnboardingLanguageViewController{
    class func instantiate() -> OnboardingLanguageViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: OnboardingLanguageViewController.identifier) as! OnboardingLanguageViewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
