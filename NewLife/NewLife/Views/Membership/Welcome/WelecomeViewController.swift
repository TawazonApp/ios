//
//  WelecomeViewController.swift
//  NewLife
//
//  Created by Shadi on 07/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftVideoBackground
import AudioToolbox
import AuthenticationServices
import SwiftyStoreKit

class WelecomeViewController: HandleErrorViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var appleIdButtonContainer: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var languageButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registerationButton: UIButton!
    @IBOutlet weak var othersLabel: UILabel!
    @IBOutlet weak var dividerView: GradientView!
    @IBOutlet weak var facbookButton: UIButton!
    @IBOutlet weak var skipLoginButton: CircularButton!
    
    var videoBackground: VideoBackground?
    let video: HomeVideoCellVM = HomeVideoCellVM(videoName: "HomeVideo1", videoType: "mp4")
    lazy var welcomeVM = WelecomeVM(service: MembershipServiceFactory.service())
    var hasAppleLogin: Bool {
        if #available(iOS 13.0, *) {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
//        playVideo()
        
        if UserDefaults.isFirstOpenedInstallSources() && !UserDefaults.isFirstOpened() {
//            self.showOnboardingInstallSourcesViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(showOnboardingInstallSourcesViewController), name: NSNotification.Name.showOnboardingInstallSources
//            , object: nil)
        
        
        if UserDefaults.isFirstOpened() {
            showOnboardingViewController()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        pauseVideo()
    }
    
    private func initialize() {
        
        self.view.backgroundColor = UIColor.clear
        logoImageView.image = UIImage(named: "LogoWithName")
        
        titleLabel.font = .munaBoldFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = "welcomeViewTitleLabel".localized
        
        registerationButton.backgroundColor = .white.withAlphaComponent(0.12)
        registerationButton.tintColor = .white
        registerationButton.roundCorners(corners: .allCorners, radius: 18)
        registerationButton.layer.cornerRadius = 18
        registerationButton.titleLabel?.font = .munaFont(ofSize: 20)
        registerationButton.setTitle("welcomeViewRegistartionButton".localized, for: .normal)
        registerationButton.setImage(UIImage(named: "RegistrationLogo"), for: .normal)
        registerationButton.centerTextAndImage(spacing: 10)
        
        othersLabel.font = .munaFont(ofSize: 14)
        othersLabel.textColor = .white
        othersLabel.textAlignment = .center
        othersLabel.backgroundColor = .darkBlueGreyThree
        othersLabel.text = "welcomeViewOthersLabel".localized
        
        dividerView.applyGradientColor(colors: [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor], startPoint: .left, endPoint: .right)
        dividerView.backgroundColor = .clear
        dividerView.alpha = 0.2
        
        
        facbookButton.backgroundColor = UIColor.facebookColor
        facbookButton.tintColor = UIColor.white
        facbookButton.titleLabel?.font = .munaFont(ofSize: 20)
        facbookButton.layer.cornerRadius = 18
        facbookButton.layer.masksToBounds = true
        facbookButton.setTitle("facebookButtonTitle".localized, for: .normal)
        facbookButton.setImage(#imageLiteral(resourceName: "FacebookLogo.pdf"), for: .normal)
        facbookButton.centerTextAndImage(spacing: 10)
        
        skipLoginButton.backgroundColor = .black.withAlphaComponent(0.62)
        skipLoginButton.setImage(UIImage(named: "Cancel"), for: .normal)
        skipLoginButton.roundCorners(corners: .allCorners, radius: 24)
        skipLoginButton.tintColor = .white
        
        skipButton.backgroundColor = UIColor.clear
        skipButton.tintColor = UIColor.white
        skipButton.setTitle("skipLoginButtonTitle".localized, for: .normal)
        skipButton.titleLabel?.font = UIFont.kacstPen(ofSize: 22)
        languageButton.tintColor = UIColor.white
        languageButton.titleLabel?.font = UIFont.kacstPen(ofSize: 14)
        languageButton.setTitle(
            "welcomeChangeLanguageButtonTitle".localized, for: .normal)
        
        startButton.setAttributedTitle(loginButtonAttributeText(), for: .normal)
        startButton.layer.cornerRadius = 18
        startButton.backgroundColor = .clear
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        registerButton.tintColor = UIColor.white
        registerButton.setAttributedTitle(registerButtonAttributeText(), for: .normal)
        registerButton.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        registerButton.layer.cornerRadius = 18
//        registerButton.isHidden = hasAppleLogin
        
        privacyPolicyButton.tintColor = UIColor.white
        privacyPolicyButton.setAttributedTitle(privacyPolicyAttributeText(), for: .normal)
        
//        startView.delegate = self
        addAppleIDButton()
        
        backgroundImageView.image = UIImage(named: "OnboardingBackground")
        backgroundImageView.contentMode = .scaleAspectFill
        
        self.view.backgroundColor = .darkBlueGreyThree
    }
    func appLaunchImage() -> UIImage? {

        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)

        for imageName in allPngImageNames
        {
            // make sure that the image name contains the string 'LaunchImage' and that we can actually create a UIImage from it.

            guard
                imageName.contains("LaunchImage"),
                let image = UIImage(named: imageName)
                else { continue }

            // if the image has the same scale AND dimensions as the current device's screen...

            if (image.scale == UIScreen.main.scale) && (image.size.equalTo(UIScreen.main.bounds.size))
            {
                return image
            }
        }

        return nil
    }
    
    private func addAppleIDButton() {
        if #available(iOS 13.0, *) {
            appleIdButtonContainer.isHidden = false
            
            let authorizationButton = ASAuthorizationAppleIDButton(type: .continue, style: .white)
            authorizationButton.translatesAutoresizingMaskIntoConstraints = false
            authorizationButton.addTarget(self, action:
                #selector(appleAuthorizationButtonTapped(_:)), for: .touchUpInside)
            
            appleIdButtonContainer.addSubview(authorizationButton)
            authorizationButton.leadingAnchor.constraint(equalTo: appleIdButtonContainer.leadingAnchor).isActive = true
            authorizationButton.widthAnchor.constraint(equalTo: appleIdButtonContainer.widthAnchor).isActive = true
            authorizationButton.topAnchor.constraint(equalTo: appleIdButtonContainer.topAnchor).isActive = true
            authorizationButton.heightAnchor.constraint(equalTo: appleIdButtonContainer.heightAnchor).isActive = true
            authorizationButton.cornerRadius = 18
        } else {
            appleIdButtonContainer.isHidden = true
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        openGoalsViewController()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        openRegisterViewController()
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: UIButton) {
        openPrivacyViewController()
    }
    
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "changeLanguageAlertTitle".localized, preferredStyle: .actionSheet, blurStyle: .dark)
         
        let englishAction = UIAlertAction(title: "English", style: .default) { [weak self]  (action) in
            self?.changeLanguage(language: .english)
        }
        if Language.language == .english {
            englishAction.setValue(true, forKey: "checked")
        }
        alert.addAction(englishAction)
        
        let arabicAction = UIAlertAction(title: "العربية", style: .default) { [weak self]  (action) in
            self?.changeLanguage(language: .arabic)
        }
        if Language.language == .arabic {
            arabicAction.setValue(true, forKey: "checked")
        }
        alert.addAction(arabicAction)
        
        alert.addAction(title: "logoutConfirmAlertCancelButton".localized, style: .cancel) { (alert) in
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func appleAuthorizationButtonTapped(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
//        delegate?.facebookButtonTapped()
        facebookLogin()
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        openLoginViewController()
    }
    
    private func facebookLogin() {
        
        let facebook = FacebookLoginVM(service: MembershipServiceFactory.service())
        
        facebook.login(fbManager: LoginManager(), viewController: self) { [weak self] (accessToken, error) in
            
            if let error = error {
                self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                return
            }
            
            guard let accessToken = accessToken else { return }
            
            LoadingHud.shared.show(animated: true)
            facebook.submit(accessToken: accessToken, completion: { [weak self] (submitError) in
                if let error = error {
                    LoadingHud.shared.hide(animated: true)
                    self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                    return
                }
                self?.userLoggedAction()
                LoadingHud.shared.hide(animated: true)
            })
            
        }
    }
    
    private func changeLanguage(language: Language) {
        guard language != Language.language else {
            return
        }
        Language.language = language
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        (UIApplication.shared.delegate as? AppDelegate)?.resetApp()
    }
    
    private func privacyPolicyAttributeText() -> NSMutableAttributedString {
        
        let privacyPolicyPart1 = "privacyPolicyPart1".localized
        let privacyPolicyPart2 = "privacyPolicyPart2".localized
        let allText = String(format: "%@ %@", privacyPolicyPart1, privacyPolicyPart2)
        
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.kacstPen(ofSize: 14), .foregroundColor: UIColor.white.withAlphaComponent(0.64),.kern: 0.0])
        
        if let part2Range = allText.range(of: privacyPolicyPart2) {
            attributedString.addAttributes([.foregroundColor: UIColor.white], range: part2Range.nsRange(in: allText))
        }
        return attributedString
    }
    
    private func loginButtonAttributeText() -> NSMutableAttributedString {
        
        let loginPart1 = "loginButtonPart1".localized
        let loginPart2 = "loginButtonPart2".localized
        let allText = String(format: "%@ %@", loginPart1, loginPart2)
        
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.munaFont(ofSize: 18), .foregroundColor: UIColor.white.withAlphaComponent(0.64),.kern: 0.0])
        
        if let part2Range = allText.range(of: loginPart2) {
            attributedString.addAttributes([.foregroundColor: UIColor.white], range: part2Range.nsRange(in: allText))
        }
        return attributedString
    }
    
    private func registerButtonAttributeText() -> NSMutableAttributedString {
        
        let part1 = "hasNotAccount".localized
        let part2 = "goToRegister".localized
        let allText = String(format: "%@ %@", part1, part2)
        
        let attributedString = NSMutableAttributedString(string: allText, attributes: [.font: UIFont.kacstPen(ofSize: 14), .foregroundColor: UIColor.white,.kern: 0.0])
        
        if let part2Range = allText.range(of: part2) {
            let location = part2Range.lowerBound.encodedOffset
            let length = part2Range.upperBound.encodedOffset - location
            attributedString.addAttributes([.font: UIFont.kacstPen(ofSize: 20)], range: NSRange(location: location, length: length))
        }
        
        return attributedString
    }
    
    private func playVideo() {
        if videoBackground == nil {
            videoBackground = VideoBackground()
        }
        
        try? videoBackground?.play(view: self.view, videoName: video.videoName, videoType: video.videoType, isMuted: true, darkness: 0, willLoopVideo: true, setAudioSessionAmbient: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.backgroundImageView.isHidden = true
        }
    }
    
    private func pauseVideo() {
        videoBackground?.pause()
        videoBackground = nil
    }
    
    private func openLoginViewController() {
        SystemSoundID.play(sound: .Sound1)
        
        let viewController = MembershipViewController.instantiate(viewType: .login)
        
        let navigationController = NavigationController.init(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
    
    private func openRegisterViewController() {
        SystemSoundID.play(sound: .Sound1)
        let viewController = MembershipViewController.instantiate(viewType: .register)
        let navigationController = NavigationController.init(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
    
    private func openGoalsViewController() {
        let viewController = GoalsListViewController.instantiate()
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: false, completion: nil)
    }
    
    private func openPrivacyViewController()  {
        let viewController = PrivacyViewController.instantiate(viewType: .termsAndConditions)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    private func showOnboardingViewController() {
        let viewController = OnboardingLanguageViewController.instantiate()

        navigationController?.present(viewController, animated: true, completion: {
            
        })
    }
    
    @objc private func showOnboardingInstallSourcesViewController() {
        let viewController = OnboardingInstallSourcesViewController.instantiate()
        
        navigationController?.present(viewController, animated: true, completion: {
            
        })
    }
}

extension WelecomeViewController: WelecomeStartViewDelegate {
    
    func startViewTapped() {
        openLoginViewController()
    }
}

extension WelecomeViewController {
    
    class func instantiate() -> WelecomeViewController {
        let storyboard = UIStoryboard(name: "Membership", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: WelecomeViewController.identifier) as! WelecomeViewController
        return viewController
    }
}

extension WelecomeViewController: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential, let identityToken = appleIDCredential.identityToken {
            let token = String(decoding: identityToken, as: UTF8.self)
            let name = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
            let loginModel = AppleLoginModel(token: token, user_id: appleIDCredential.user, name: name, email: appleIDCredential.email)
            
            LoadingHud.shared.show(animated: true)
            welcomeVM.appleLogin(data: loginModel) { [weak self] (error) in
                if let error = error {
                    LoadingHud.shared.hide(animated: true)
                    self?.showErrorMessage(message: error.message ?? "generalErrorMessage".localized)
                    return
                }
                self?.userLoggedAction()
                LoadingHud.shared.hide(animated: true)
            }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorizationController error: \(error)")
        
    }
}


extension WelecomeViewController {
    private func userLoggedAction() {
        if let appDelegate =  UIApplication.shared.delegate as? AppDelegate {
            appDelegate.sendFcmToken()
            openCorrectViewController()
        }
    }
    

    
    private func openCorrectViewController() {
        if UserDefaults.isUserSelectGoals() == false {
            openGoalsViewController()
        } else {
            openMainViewController()
        }
    }
    
    private func openMainViewController() {
        SystemSoundID.play(sound: .LaunchToHome)
        self.view.endEditing(true)
        (UIApplication.shared.delegate as? AppDelegate)?.pushWindowToRootViewController(viewController: MainTabBarController.instantiate(), animated: true)
    }
}
